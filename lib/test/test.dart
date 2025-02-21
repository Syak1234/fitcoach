import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WorkoutProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
      routes: {
        '/track': (context) => WorkoutTrackingScreen(),
        '/history': (context) => WorkoutHistoryScreen(),
      },
    );
  }
}

// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProgressChart(workoutProvider.workouts),
            _buildQuickActions(context),
            _buildRecentWorkouts(workoutProvider.workouts),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(List<Map<String, dynamic>> workouts) {
    final List<BarChartGroupData> barGroups = workouts.map((workout) {
      return BarChartGroupData(
        x: workouts.indexOf(workout),
        barRods: [
          BarChartRodData(
            toY: workout['duration'].toDouble(),
            color: Colors.blue,
            // colors: [Colors.blue],
          ),
        ],
      );
    }).toList();

    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(workouts[value.toInt()]['name']);
              },
            )
                // showTitles: true,
                // getTitles: (double value) {
                //   return workouts[value.toInt()]['name'];
                // },
                ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.add,
          label: 'Add Workout',
          onPressed: () => Navigator.pushNamed(context, '/track'),
        ),
        _ActionButton(
          icon: Icons.history,
          label: 'History',
          onPressed: () => Navigator.pushNamed(context, '/history'),
        ),
      ],
    );
  }

  Widget _buildRecentWorkouts(List<Map<String, dynamic>> workouts) {
    return Column(
      children: [
        ListTile(
          title: Text('Recent Workouts'),
          subtitle: Text('You completed ${workouts.length} workouts'),
        ),
        ...workouts.reversed.take(3).map((workout) {
          return ListTile(
            title: Text(workout['name']),
            subtitle: Text('Duration: ${workout['duration']} minutes'),
            trailing: Text(workout['date']),
          );
        }).toList(),
      ],
    );
  }
}

// Workout Tracking Screen
class WorkoutTrackingScreen extends StatefulWidget {
  @override
  _WorkoutTrackingScreenState createState() => _WorkoutTrackingScreenState();
}

class _WorkoutTrackingScreenState extends State<WorkoutTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _workoutName = '';
  int _duration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Workout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Workout Name'),
                onSaved: (value) => _workoutName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _duration = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveWorkout,
                child: Text('Save Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      workoutProvider.addWorkout(_workoutName, _duration);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout saved!')),
      );
      Navigator.pop(context);
    }
  }
}

// Workout History Screen
class WorkoutHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: ListView.builder(
        itemCount: workoutProvider.workouts.length,
        itemBuilder: (context, index) {
          final workout = workoutProvider.workouts[index];
          return ListTile(
            title: Text(workout['name']),
            subtitle: Text('Duration: ${workout['duration']} minutes'),
            trailing: Text(workout['date']),
          );
        },
      ),
    );
  }
}

// Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  _ActionButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(icon: Icon(icon), onPressed: onPressed),
        Text(label),
      ],
    );
  }
}

// Workout Provider (State Management)
class WorkoutProvider with ChangeNotifier {
  List<Map<String, dynamic>> _workouts = [];
  SharedPreferences? _prefs;

  WorkoutProvider() {
    _loadWorkouts();
  }

  List<Map<String, dynamic>> get workouts => _workouts;

  Future<void> _loadWorkouts() async {
    _prefs = await SharedPreferences.getInstance();
    final savedWorkouts = _prefs!.getString('workouts');
    if (savedWorkouts != null) {
      _workouts = List<Map<String, dynamic>>.from(jsonDecode(savedWorkouts));
    }
    notifyListeners();
  }

  void addWorkout(String name, int duration) {
    _workouts.add({
      'name': name,
      'duration': duration,
      'date': DateTime.now().toString(),
    });
    _saveWorkouts();
    notifyListeners();
  }

  Future<void> _saveWorkouts() async {
    await _prefs!.setString('workouts', jsonEncode(_workouts));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      home: WorkoutPlansScreen(),
      routes: {
        '/add': (context) => AddWorkoutScreen(),
      },
    );
  }
}

// Workout Plans Screen
class WorkoutPlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plans'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/add'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: workoutProvider.workouts.length,
        itemBuilder: (context, index) {
          final workout = workoutProvider.workouts[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(workout['name']),
              subtitle: Text('${workout['exercises'].length} exercises'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => workoutProvider.deleteWorkout(index),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetailScreen(workoutIndex: index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Add Workout Screen
class AddWorkoutScreen extends StatefulWidget {
  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _workoutName = '';
  final List<Map<String, dynamic>> _exercises = [];

  void _addExercise(String name, int sets, int reps, int duration) {
    setState(() {
      _exercises.add({
        'name': name,
        'sets': sets,
        'reps': reps,
        'duration': duration,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout Plan'),
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
              SizedBox(height: 20),
              Text('Exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ..._exercises.map((exercise) {
                return ListTile(
                  title: Text(exercise['name']),
                  subtitle: Text('Sets: ${exercise['sets']}, Reps: ${exercise['reps']}, Duration: ${exercise['duration']} mins'),
                );
              }).toList(),
              ElevatedButton(
                onPressed: () => _showAddExerciseDialog(),
                child: Text('Add Exercise'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveWorkout,
                child: Text('Save Workout Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddExerciseDialog() {
    String name = '';
    int sets = 0;
    int reps = 0;
    int duration = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Exercise Name'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
                onChanged: (value) => sets = int.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                onChanged: (value) => reps = int.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration (mins)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => duration = int.parse(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addExercise(name, sets, reps, duration);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
      workoutProvider.addWorkout(_workoutName, _exercises);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout Plan Saved!')),
      );
      Navigator.pop(context);
    }
  }
}

// Workout Detail Screen
class WorkoutDetailScreen extends StatelessWidget {
  final int workoutIndex;

  WorkoutDetailScreen({required this.workoutIndex});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workout = workoutProvider.workouts[workoutIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(workout['name']),
      ),
      body: ListView.builder(
        itemCount: workout['exercises'].length,
        itemBuilder: (context, index) {
          final exercise = workout['exercises'][index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(exercise['name']),
              subtitle: Text('Sets: ${exercise['sets']}, Reps: ${exercise['reps']}, Duration: ${exercise['duration']} mins'),
              trailing: Checkbox(
                value: exercise['completed'] ?? false,
                onChanged: (value) {
                  workoutProvider.toggleExerciseCompletion(workoutIndex, index, value!);
                },
              ),
            ),
          );
        },
      ),
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

  void addWorkout(String name, List<Map<String, dynamic>> exercises) {
    _workouts.add({
      'name': name,
      'exercises': exercises,
    });
    _saveWorkouts();
    notifyListeners();
  }

  void deleteWorkout(int index) {
    _workouts.removeAt(index);
    _saveWorkouts();
    notifyListeners();
  }

  void toggleExerciseCompletion(int workoutIndex, int exerciseIndex, bool completed) {
    _workouts[workoutIndex]['exercises'][exerciseIndex]['completed'] = completed;
    _saveWorkouts();
    notifyListeners();
  }

  Future<void> _saveWorkouts() async {
    await _prefs!.setString('workouts', jsonEncode(_workouts));
  }
}
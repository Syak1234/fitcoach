import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HealthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HealthDashboardScreen(),
    );
  }
}

// Health Dashboard Screen
class HealthDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final healthProvider = Provider.of<HealthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHealthMetrics(healthProvider),
            _buildAnalyticsCharts(healthProvider),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHealthDataDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHealthMetrics(HealthProvider healthProvider) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text('Steps'),
              subtitle: Text('${healthProvider.steps} steps today'),
            ),
            ListTile(
              title: Text('Calories Burned'),
              subtitle: Text('${healthProvider.calories} kcal today'),
            ),
            ListTile(
              title: Text('Heart Rate'),
              subtitle: Text('${healthProvider.heartRate} bpm today'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCharts(HealthProvider healthProvider) {
    return Column(
      children: [
        _buildLineChart(healthProvider.stepsData, 'Steps'),
        _buildLineChart(healthProvider.caloriesData, 'Calories Burned'),
        _buildLineChart(healthProvider.heartRateData, 'Heart Rate'),
      ],
    );
  }

  Widget _buildLineChart(List<FlSpot> data, String title) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      // preventCurveOverShooting: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddHealthDataDialog(BuildContext context) {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    int steps = 0;
    int calories = 0;
    int heartRate = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Health Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Steps'),
                keyboardType: TextInputType.number,
                onChanged: (value) => steps = int.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Calories Burned'),
                keyboardType: TextInputType.number,
                onChanged: (value) => calories = int.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Heart Rate (bpm)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => heartRate = int.parse(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                healthProvider.addHealthData(steps, calories, heartRate);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

// Health Provider (State Management)
class HealthProvider with ChangeNotifier {
  int _steps = 0;
  int _calories = 0;
  int _heartRate = 0;
  List<FlSpot> _stepsData = [];
  List<FlSpot> _caloriesData = [];
  List<FlSpot> _heartRateData = [];
  SharedPreferences? _prefs;

  HealthProvider() {
    _loadHealthData();
  }

  int get steps => _steps;
  int get calories => _calories;
  int get heartRate => _heartRate;
  List<FlSpot> get stepsData => _stepsData;
  List<FlSpot> get caloriesData => _caloriesData;
  List<FlSpot> get heartRateData => _heartRateData;

  Future<void> _loadHealthData() async {
    _prefs = await SharedPreferences.getInstance();
    _steps = _prefs!.getInt('steps') ?? 0;
    _calories = _prefs!.getInt('calories') ?? 0;
    _heartRate = _prefs!.getInt('heartRate') ?? 0;
    _stepsData = _parseChartData(_prefs!.getString('stepsData'));
    _caloriesData = _parseChartData(_prefs!.getString('caloriesData'));
    _heartRateData = _parseChartData(_prefs!.getString('heartRateData'));
    notifyListeners();
  }

  List<FlSpot> _parseChartData(String? data) {
    if (data == null) return [];
    final List<dynamic> decodedData = jsonDecode(data);
    return decodedData.map((item) => FlSpot(item['x'], item['y'])).toList();
  }

  void addHealthData(int steps, int calories, int heartRate) {
    _steps += steps;
    _calories += calories;
    _heartRate = heartRate;

    _stepsData.add(FlSpot(_stepsData.length.toDouble(), _steps.toDouble()));
    _caloriesData
        .add(FlSpot(_caloriesData.length.toDouble(), _calories.toDouble()));
    _heartRateData
        .add(FlSpot(_heartRateData.length.toDouble(), _heartRate.toDouble()));

    _saveHealthData();
    notifyListeners();
  }

  Future<void> _saveHealthData() async {
    await _prefs!.setInt('steps', _steps);
    await _prefs!.setInt('calories', _calories);
    await _prefs!.setInt('heartRate', _heartRate);

    // Convert FlSpot objects to a JSON-encodable format
    final stepsDataEncoded =
        _stepsData.map((spot) => {'x': spot.x, 'y': spot.y}).toList();
    final caloriesDataEncoded =
        _caloriesData.map((spot) => {'x': spot.x, 'y': spot.y}).toList();
    final heartRateDataEncoded =
        _heartRateData.map((spot) => {'x': spot.x, 'y': spot.y}).toList();

    await _prefs!.setString('stepsData', jsonEncode(stepsDataEncoded));
    await _prefs!.setString('caloriesData', jsonEncode(caloriesDataEncoded));
    await _prefs!.setString('heartRateData', jsonEncode(heartRateDataEncoded));
  }
}

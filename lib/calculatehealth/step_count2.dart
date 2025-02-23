import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StepCount1 extends StatefulWidget {
  @override
  _StepCount1State createState() => _StepCount1State();
}

class _StepCount1State extends State<StepCount1> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  int _initialSteps = 0;
  int _todaySteps = 0;
  int _minutesWalked = 0;
  Map<String, int> _stepHistory = {}; // Store step count date-wise
  String _selectedDate = DateTime.now().toIso8601String().substring(0, 10);

  final double stepLength = 0.75; // Average step length in meters
  final double caloriesPerStep = 0.04; // Approximate calories per step
  final double stepsPerMinute = 100; // Approximate walking speed

  @override
  void initState() {
    super.initState();
    _loadStepHistory();
    initPlatformState();
  }

  Future<void> _loadStepHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stepData = prefs.getString("step_history");

    if (stepData != null) {
      _stepHistory = Map<String, int>.from(json.decode(stepData));
    }

    setState(() {
      _todaySteps = _stepHistory[_selectedDate] ?? 0;
      _minutesWalked = (_todaySteps / stepsPerMinute).toInt();
    });
  }

  Future<void> _saveStepHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("step_history", json.encode(_stepHistory));
  }

  void onStepCount(StepCount event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentSteps = event.steps;

    // Get stored initial step count for today
    int? savedInitialSteps = prefs.getInt("initial_steps_$_selectedDate");

    if (savedInitialSteps == null) {
      // Save the first step count of the day
      await prefs.setInt("initial_steps_$_selectedDate", currentSteps);
      savedInitialSteps = currentSteps;
    }

    setState(() {
      _initialSteps = savedInitialSteps!;
      _todaySteps = currentSteps - _initialSteps;
      _minutesWalked = (_todaySteps / stepsPerMinute).toInt();
      _stepHistory[_selectedDate] = _todaySteps;
    });

    _saveStepHistory();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }
    return granted;
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) return;

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError((error) {
      setState(() => _status = 'Status unavailable');
    });

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError((error) {
      setState(() => _todaySteps = 0);
    });
  }

  void _selectDate(String date) {
    setState(() {
      _selectedDate = date;
      _todaySteps = _stepHistory[date] ?? 0;
      _minutesWalked = (_todaySteps / stepsPerMinute).toInt();
    });
  }

  double get distanceInKm => (_todaySteps * stepLength) / 1000;
  double get caloriesBurned => _todaySteps * caloriesPerStep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedometer Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Steps on $_selectedDate', style: TextStyle(fontSize: 25)),
            Text('$_todaySteps', style: TextStyle(fontSize: 50)),
            SizedBox(height: 10),
            Text('Distance: ${distanceInKm.toStringAsFixed(2)} km',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Calories: ${caloriesBurned.toStringAsFixed(2)} kcal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Minutes Walked: $_minutesWalked min',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024, 1, 1),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  _selectDate(pickedDate.toIso8601String().substring(0, 10));
                }
              },
              child: Text("Select Date"),
            ),
            SizedBox(height: 50),
            Text('Pedestrian Status', style: TextStyle(fontSize: 25)),
            Icon(
              _status == 'walking'
                  ? Icons.directions_walk
                  : _status == 'stopped'
                      ? Icons.accessibility_new
                      : Icons.error,
              size: 100,
            ),
            Text(
              _status,
              style: TextStyle(
                  fontSize: 25,
                  color: _status == 'walking' || _status == 'stopped'
                      ? Colors.black
                      : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

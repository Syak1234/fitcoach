import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  int _steps = 0;
  int _initialSteps = 0;
  int _todaySteps = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialStepCount();
    initPlatformState();
  }

  Future<void> _loadInitialStepCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedSteps = prefs.getInt("initial_steps");
    String? lastDate = prefs.getString("last_saved_date");
    String today = DateTime.now().toIso8601String().substring(0, 10);

    if (savedSteps == null || lastDate != today) {
      // Reset initial step count if the date changed
      prefs.setInt("initial_steps", _steps);
      prefs.setString("last_saved_date", today);
      _initialSteps = _steps;
    } else {
      _initialSteps = savedSteps;
    }
    setState(() {
      _todaySteps = _steps - _initialSteps;
    });
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps;
      _todaySteps = _steps - _initialSteps;
    });
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
      setState(() => _steps = 0);
    });

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pedometer Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Steps Today', style: TextStyle(fontSize: 30)),
              Text('$_todaySteps', style: TextStyle(fontSize: 60)),
              SizedBox(height: 50),
              Text('Total Steps', style: TextStyle(fontSize: 30)),
              Text('$_steps', style: TextStyle(fontSize: 40)),
              SizedBox(height: 50),
              Text('Pedestrian Status', style: TextStyle(fontSize: 30)),
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
                style: TextStyle(fontSize: 30, color: _status == 'walking' || _status == 'stopped' ? Colors.black : Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

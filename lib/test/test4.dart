import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HealthDataScreen(),
    );
  }
}

class HealthDataScreen extends StatefulWidget {
  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  Health health = Health();
  List<HealthDataPoint> healthData = [];

  @override
  void initState() {
    super.initState();
    _initHealth();
  }

  Future<void> _initHealth() async {
    // Request permissions
    bool requested = await health.requestAuthorization([
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ]);

    if (requested) {
      _fetchHealthData();
    } else {
      print("Permission not granted");
    }
  }

  Future<void> _fetchHealthData() async {
    // Define the time range for the data
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 360));

    // Fetch heart rate data
    List<HealthDataPoint> heartRateData = await health.getHealthDataFromTypes(

        // yesterday,
        // now,
        types: [HealthDataType.HEART_RATE],
        startTime: yesterday,
        endTime: now);

    // Fetch steps data
    //  DateTime now = DateTime.now();
    // DateTime oneMonthAgo = now.subtract(Duration(days: 30));

    List<HealthDataPoint> stepsData = await health.getHealthDataFromTypes(
      startTime: yesterday,
      endTime: now,
      types: [HealthDataType.STEPS],
    );

    // Fetch calories burned data
    List<HealthDataPoint> caloriesData = await health.getHealthDataFromTypes(
      startTime: yesterday, endTime: now,
      types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      // [HealthDataType.ACTIVE_ENERGY_BURNED],
    );

    setState(() {
      healthData = [...heartRateData, ...stepsData, ...caloriesData];
    });
    log(healthData[0].value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Data'),
      ),
      body: ListView.builder(
        itemCount: healthData.length,
        itemBuilder: (context, index) {
          final data = healthData[index];
          return ListTile(
            title: Text('${data.typeString}: ${data.value}'),
            subtitle: Text('Date: ${data.dateFrom}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchHealthData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

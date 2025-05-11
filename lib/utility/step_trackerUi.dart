import 'dart:convert';
import 'dart:developer';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pedometer/pedometer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class StepsTakenScreen extends StatefulWidget {
  @override
  State<StepsTakenScreen> createState() => _StepsTakenScreenState();
}

class _StepsTakenScreenState extends State<StepsTakenScreen> {
  final StepsController controller = Get.find<StepsController>();
  Getx getx = Get.put(Getx());
  @override
  void initState() {
    super.initState();
    uploadStepData();
  }

  Future uploadStepData() async {
    if (controller.todaySteps.value != 0) {
      await createStepData(
              context: context,
              userId: getx.userdetails[0].userId, // Replace with dynamic userId
              date: DateTime.now().toIso8601String(),
              step: controller.todaySteps.value,
              kcal: controller.caloriesBurned.value.toStringAsFixed(1),
              km: controller.distanceInKm.value.toStringAsFixed(2),
              minutes: controller.minutesWalked.value)
          .then((val) {
        if (val == false) {
          controller.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Steps Taken",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final List<ChartData> chartData = [
          ChartData(
              2,
              controller.caloriesBurned.value,
              '${(controller.caloriesBurned.value / 500 * 100).toInt()}%',
              Colors.orange),
          ChartData(
              1,
              controller.distanceInKm.value * 1000,
              '${(controller.distanceInKm.value / 10 * 100).toInt()}%',
              Colors.grey),
          ChartData(
              0,
              controller.todaySteps.value.toDouble(),
              '${(controller.todaySteps.value / 10000 * 100).toInt()}%',
              Colors.blue),
        ];

        return Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: Container(
                width: 280,
                height: 280,
                child: SfCircularChart(
                  series: <RadialBarSeries<ChartData, int>>[
                    RadialBarSeries<ChartData, int>(
                      radius: '120%',
                      useSeriesColor: true,
                      gap: '10%',
                      trackOpacity: 0.1,
                      dataSource: chartData,
                      pointRadiusMapper: (ChartData data, _) => data.opacity,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("${controller.todaySteps.value}",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            Text("total steps",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                      "${controller.caloriesBurned.value.toStringAsFixed(1)}",
                      "kcal",
                      Colors.orange,
                      Icons.local_fire_department),
                  _buildInfoCard(
                      "${controller.distanceInKm.value.toStringAsFixed(2)}",
                      "km",
                      Colors.grey,
                      Icons.place),
                  _buildInfoCard("${controller.minutesWalked.value}", "minutes",
                      Colors.blue, Icons.access_time),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoCard(
      String value, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        SizedBox(height: 8),
        Text(value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}

class StepsController extends GetxController {
  RxInt todaySteps = 0.obs;
  var totalIntake = 0.obs;
  var dailyGoal = 2000.obs;
  RxInt minutesWalked = 0.obs;
  RxDouble distanceInKm = 0.0.obs;
  RxDouble caloriesBurned = 0.0.obs;
  // RxBool hasSentDataToday = false.obs;

  Map<String, int> stepHistory = {};
  String selectedDate = DateTime.now().toIso8601String().substring(0, 10);

  final double stepLength = 0.75;
  final double caloriesPerStep = 0.04;
  final double stepsPerMinute = 100;
  late Stream<StepCount> stepCountStream;
  late Stream<PedestrianStatus> pedestrianStatusStream;

  @override
  void onInit() {
    super.onInit();
    _loadStepHistory();
    // _loadSendStatus();
    initPlatformState().whenComplete(
      () {
        call();
      },
    );
  }

  call() async {
    log("message" + getx.steptodayid.value);

    await updateData(
        // Replace with dynamic userId
        date: DateTime.now().toIso8601String(),
        step: todaySteps.value,
        kcal: caloriesBurned.value.toStringAsFixed(1),
        km: distanceInKm.value.toStringAsFixed(2),
        minutes: minutesWalked.value,
        id: getx.steptodayid.value);
  }

  Future<void> _loadStepHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stepData = prefs.getString("step_history");
    if (stepData != null) {
      stepHistory = Map<String, int>.from(json.decode(stepData));
    }
    todaySteps.value = stepHistory[selectedDate] ?? 0;
    minutesWalked.value = (todaySteps.value / stepsPerMinute).toInt();
    updateMetrics();
  }

  Future<void> _saveStepHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("step_history", json.encode(stepHistory));
  }

  void onStepCount(StepCount event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentSteps = event.steps;
    int? savedInitialSteps = prefs.getInt("initial_steps_$selectedDate");

    if (savedInitialSteps == null) {
      await prefs.setInt("initial_steps_$selectedDate", currentSteps);
      savedInitialSteps = currentSteps;
    }

    todaySteps.value = (currentSteps - savedInitialSteps) < 0
        ? 0
        : currentSteps - savedInitialSteps;
    minutesWalked.value = (todaySteps.value / stepsPerMinute).toInt();
    stepHistory[selectedDate] = todaySteps.value;
    await _saveStepHistory();
    updateMetrics();
    final userid = await SharedPrefHelper.getString('userid');

    // if (success) {
    //   hasSentDataToday.value = true;
    //   prefs.setBool("has_sent_data_$selectedDate", true);
    // }
  }

  void updateMetrics() {
    distanceInKm.value = (todaySteps.value * stepLength) / 1000;
    caloriesBurned.value = todaySteps.value * caloriesPerStep;
  }

  // Future<void> _loadSendStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // hasSentDataToday.value =
  //   //     prefs.getBool("has_sent_data_$selectedDate") ?? false;
  // }

  void onPedestrianStatusChanged(PedestrianStatus event) {}

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

    pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError((error) {});

    stepCountStream = Pedometer.stepCountStream;
    stepCountStream.listen(onStepCount).onError((error) {
      todaySteps.value = 0;
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.opacity, this.color);
  final int x;
  final double y;
  final String opacity;
  final Color color;
}

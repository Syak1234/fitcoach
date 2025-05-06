import 'dart:convert';
import 'dart:developer';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pedometer/pedometer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class StepsTakenScreen extends StatelessWidget {
  final StepsController controller = Get.put(StepsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Text("Steps Taken",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final List<ChartData> chartData = [
          ChartData(
              2,
              controller.caloriesBurned.value,
              '${(controller.caloriesBurned.value / 500 * 100).toInt()}%',
              AppColors.blue60),
          ChartData(
              1,
              controller.distanceInKm.value * 1000,
              '${(controller.distanceInKm.value / 10 * 100).toInt()}%',
              AppColors.gray80),
          ChartData(
              0,
              controller.todaySteps.value.toDouble(),
              '${(controller.todaySteps.value / 10000 * 100).toInt()}%',
              AppColors.primaryorange),
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
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            Text("total steps",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray)),
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                      "${controller.caloriesBurned.value.toStringAsFixed(1)}",
                      "kcal",
                      AppColors.primaryorange,
                      Icons.local_fire_department),
                  _buildInfoCard(
                      "${controller.distanceInKm.value.toStringAsFixed(2)}",
                      "km",
                      AppColors.gray80,
                      Icons.place),
                  _buildInfoCard("${controller.minutesWalked.value}", "minutes",
                      AppColors.blue60, Icons.access_time),
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
          child: Icon(icon, color: AppColors.textLight, size: 30),
        ),
        SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        Text(label, style: TextStyle(fontSize: 14, color: AppColors.gray)),
      ],
    );
  }
}

class StepsController extends GetxController {
  RxInt todaySteps = 0.obs;
  RxInt minutesWalked = 0.obs;
  RxDouble distanceInKm = 0.0.obs;
  RxDouble caloriesBurned = 0.0.obs;
  RxString status = '?'.obs;

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
    initPlatformState();
  }

  Future<void> _loadStepHistory() async {
    log(selectedDate.toString());
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
    await sendStepDataToApi(); // <-- 🔁 Send data to API
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    status.value = event.status;
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

    pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    pedestrianStatusStream.listen(onPedestrianStatusChanged).onError((error) {
      status.value = 'Status unavailable';
    });

    stepCountStream = Pedometer.stepCountStream;
    stepCountStream.listen(onStepCount).onError((error) {
      todaySteps.value = 0;
    });
  }

  void updateMetrics() {
    distanceInKm.value = (todaySteps.value * stepLength) / 1000;
    caloriesBurned.value = todaySteps.value * caloriesPerStep;
  }

  /// ✅ API sending logic
  Future<void> sendStepDataToApi() async {
    final url = Uri.parse("https://your.api.endpoint/steps"); // Replace this

    final data = {
      "date": selectedDate,
      "steps": todaySteps.value,
      "kcal": caloriesBurned.value.toStringAsFixed(1),
      "km": distanceInKm.value.toStringAsFixed(2),
      "minutes": minutesWalked.value,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN', // Uncomment if needed
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        log("✅ Step data successfully sent to API.");
      } else {
        log("❌ Failed to send data: ${response.statusCode}");
        log("Response: ${response.body}");
      }
    } catch (e) {
      log("❗ Error sending step data: $e");
    }
  }
}

class ChartData {
  ChartData(this.x, this.y, this.opacity, this.color);
  final int x;
  final double y;
  final String opacity;
  final Color color;
}

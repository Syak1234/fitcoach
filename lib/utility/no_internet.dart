import 'package:fitcoach/calculatehealth/health.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../calculatehealth/step_counter.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/utility/no_internet.png',
                width: 276,
                height: 272,
                opacity: AlwaysStoppedAnimation(0.3),
              ),
            ),
            // const Icon(
            //   Icons.wifi_off_rounded,
            //   size: 150,
            //   color: Colors.white,
            // ),
            const SizedBox(height: 20),
            Text(
              "No Internet",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSize.mediumfontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "It seems you don’t have internet.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Add your refresh logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redOpacity,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: const Color.fromARGB(186, 244, 67, 54), width: 1),
                  borderRadius: BorderRadius.circular(13),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              // label: null,
              icon: Icon(
                Icons.refresh,
                color: Colors.red,
              ),
              label: const Text(
                "Refresh or try again!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryorange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                  onPressed: () {
                    // void main() {
                    HealthCalculator userHealth = HealthCalculator(
                      height: 164.592,
                      weight: 55,
                      age: 24,
                      gender: "Male",
                      exerciseDays: 0,
                      calorieGoal: 2200,
                      dietPreference: "Plant Based", // Choose from the list
                      sleepQuality: 0.8,
                      exercisePreference: "Other", // Choose from the list
                    );
                    print("BMI: ${userHealth.calculateBMI()}");
                    print("BMR: ${userHealth.calculateBMR()} kcal/day");
                    print(
                        "Daily Calories Needed: ${userHealth.calculateDailyCalories()} kcal");
                    print(
                        "Exercise Score: ${userHealth.calculateExerciseScore()}");
                    print("Diet Score: ${userHealth.calculateDietScore()}");
                    print(
                        "Overall Health Score: ${userHealth.calculateHealthScore()}%");
                    Get.to(() => StepCounterApp());

                    // Navigate to Home
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Take Me Home",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(width: 8),
                      Icon(Icons.home, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

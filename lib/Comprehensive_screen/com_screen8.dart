import 'package:fitcoach/Comprehensive_screen/com_screen9.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComScreen8 extends StatefulWidget {
  const ComScreen8({super.key});

  @override
  State<ComScreen8> createState() => _ComScreen8State();
}

class _ComScreen8State extends State<ComScreen8> {
  @override
  Widget build(BuildContext context) {
    final Getx controller = Get.put(Getx());

    // Exercise Options
    final List<Map<String, dynamic>> exercises = [
      {'name': 'Jogging', 'icon': Icons.directions_run},
      {'name': 'Walking', 'icon': Icons.directions_walk},
      {'name': 'Hiking', 'icon': Icons.hiking},
      {'name': 'Skating', 'icon': Icons.skateboarding},
      {'name': 'Biking', 'icon': Icons.pedal_bike},
      {'name': 'Weightlift', 'icon': Icons.fitness_center},
      {'name': 'Cardio', 'icon': Icons.monitor_heart},
      {'name': 'Yoga', 'icon': Icons.self_improvement},
      {'name': 'Other', 'icon': Icons.settings},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Assessment",
          style: TextStyle(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Skip",
                style: TextStyle(color: AppColors.textLight),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar

            const SizedBox(height: 30),

            // Heading
            Center(
              child: const Text(
                "Do you have a specific\nExercise Preference?",
                style: TextStyle(
                    fontSize: AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Exercise Grid with Multiple Selection
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Obx(() {
                    bool isSelected = controller.selectedPreferences
                        .contains(exercise['name']);
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          controller.selectedPreferences
                              .remove(exercise['name']);
                        } else {
                          controller.selectedPreferences.add(exercise['name']);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryorange
                              : AppColors.gray10,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryorange
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              exercise['icon'],
                              size: 30,
                              color: isSelected
                                  ? AppColors.textLight
                                  : AppColors.gray,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              exercise['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.textLight
                                    : AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            // Continue Button
            ElevatedButton(
              onPressed: () {
                if (controller.selectedPreferences.isNotEmpty) {
                  Get.toNamed(
                    AppRoutes.comScreen9,
                  );
                } else {
                  Get.snackbar(
                      "Error", "Please select at least one exercise preference",
                      backgroundColor: Colors.deepOrange,
                      colorText: AppColors.textLight);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundDark,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Continue",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: AppColors.textLight),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

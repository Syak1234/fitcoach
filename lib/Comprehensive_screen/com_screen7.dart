import 'package:fitcoach/Comprehensive_screen/com_screen8.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GetxController/getx.dart';

class ComScreen7 extends StatefulWidget {
  const ComScreen7({super.key});

  @override
  State<ComScreen7> createState() => _ComScreen7State();
}

class _ComScreen7State extends State<ComScreen7> {
  Future<void> _savePreferences(int days) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('work_day_commit', days);
  }

  @override
  Widget build(BuildContext context) {
    final Getx controller = Get.put(Getx());

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
                "How many days/wk\nwill you commit?",
                style: TextStyle(
                    fontSize: AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Big Number Display
            Obx(() => Center(
                  child: Text(
                    "${controller.selectedDays.value}x",
                    style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark),
                    textScaler: TextScaler.linear(2),
                  ),
                )),
            const SizedBox(height: 20),

            // Days Selection Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.gray10,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (index) {
                    int day = index + 1;
                    return Obx(() => GestureDetector(
                          onTap: () => controller.selectedDays.value = day,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              // shape: BoxShape.circle,

                              color: controller.selectedDays.value == day
                                  ? AppColors.blue60
                                  : Colors.transparent,
                              // border: Border.all(color: AppColors.textLight54),
                            ),
                            child: Text(
                              "$day",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: controller.selectedDays.value == day
                                    ? AppColors.textLight
                                    : AppColors.gray,
                              ),
                            ),
                          ),
                        ));
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Commitment Text
            Obx(() => Center(
                  child: Text(
                    "I'm committed to exercising ${controller.selectedDays.value}x weekly",
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            // const Spacer(),
            SizedBox(
              height: 40,
            ),

            // Continue Button
            ElevatedButton(
              onPressed: () {
                _savePreferences(controller.selectedDays.value);
                Get.toNamed(
                  AppRoutes.comScreen8,
                );
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

import 'dart:developer';

import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GetxController/getx.dart';
import '../routes/app_routes.dart';

class HeightSelectionScreen extends StatelessWidget {
  final Getx controller = Get.put(Getx());

  final FocusNode feetFocusNode = FocusNode();
  final FocusNode inchesFocusNode = FocusNode();
  final FocusNode cmFocusNode = FocusNode();

  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();
  final TextEditingController cmController = TextEditingController();

  // Save height in cm to SharedPreferences
  Future<void> _saveHeightToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    int heightInCm;

    if (controller.isFeetAndInches.value) {
      // Convert feet & inches to cm
      heightInCm =
          ((controller.feet.value * 30.48) + (controller.inches.value * 2.54))
              .round();
    } else {
      heightInCm = controller.cm.value;
    }

    await prefs.setInt("user_height_cm", heightInCm);
    log("Saved height: $heightInCm cm");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "How tall are you?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 80),

            // Number Picker for Height Selection
            Obx(() => controller.isFeetAndInches.value
                ? Center(child: _buildNumberPicker(true)) // Feet & Inches
                : Center(child: _buildNumberPicker(false))), // Centimeters

            SizedBox(height: 20),

            // Toggle between cm and ft & in
            Obx(() => Center(
                  child: ToggleButtons(
                    fillColor: AppColors.primaryorange,
                    selectedColor: AppColors.textLight,
                    borderRadius: BorderRadius.circular(20),
                    isSelected: [
                      !controller.isFeetAndInches.value,
                      controller.isFeetAndInches.value
                    ],
                    onPressed: (index) {
                      controller.isFeetAndInches.value = index == 1;
                      if (index == 0) {
                        // Convert ft & in to cm when switching to cm mode
                        controller.cm.value = ((controller.feet.value * 30.48) +
                                (controller.inches.value * 2.54))
                            .round();
                        cmController.text = controller.cm.value.toString();
                      } else {
                        // Convert cm to ft & in when switching to ft & in mode
                        double totalInches = controller.cm.value / 2.54;
                        controller.feet.value = (totalInches ~/ 12);
                        controller.inches.value = (totalInches % 12).round();
                        feetController.text = controller.feet.value.toString();
                        inchesController.text =
                            controller.inches.value.toString();
                      }
                    },
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "cm",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "ft & in",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )),

            Spacer(),

            // Continue Button
            Obx(
              () => ElevatedButton(
                onPressed: controller.isValidHeight
                    ? () async {
                        await _saveHeightToPreferences();

                        String heightString;
                        if (controller.isFeetAndInches.value) {
                          heightString =
                              "${controller.feet.value}ft${controller.inches.value}in";
                        } else {
                          heightString = "${controller.cm.value}cm";
                        }

                        await SharedPrefHelper.setString(
                            "height", heightString);

                        Get.toNamed(AppRoutes.comScreen4);
                      }
                    : null,
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
            ),
          ],
        ),
      ),
    );
  }

  /// Builds Number Picker for Height Selection
  Widget _buildNumberPicker(bool isFeetInches) {
    return Form(
      child: isFeetInches
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Feet Input
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    controller: feetController,
                    focusNode: feetFocusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40),
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: '0',
                      hintStyle: TextStyle(fontSize: 40, color: AppColors.gray),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        controller.feet.value = int.tryParse(value) ?? 0;
                        FocusScope.of(feetFocusNode.context!)
                            .requestFocus(inchesFocusNode);
                      }
                    },
                  ),
                ),
                SizedBox(width: 5),
                Text('ft',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                // Inches Input
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: inchesController,
                    focusNode: inchesFocusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: '0',
                      hintStyle: TextStyle(fontSize: 40, color: AppColors.gray),
                    ),
                    onChanged: (value) {
                      int inches = int.tryParse(value) ?? 0;
                      if (inches >= 12) {
                        controller.feet.value += inches ~/ 12;
                        controller.inches.value = inches % 12;
                      } else {
                        controller.inches.value = inches;
                      }
                    },
                  ),
                ),
                SizedBox(width: 5),
                Text('in',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: cmController,
                    focusNode: cmFocusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: '0',
                      hintStyle: TextStyle(fontSize: 40, color: AppColors.gray),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.cm.value = int.tryParse(value) ?? 0;
                      }
                    },
                  ),
                ),
                SizedBox(width: 5),
                Text('cm',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
    );
  }
}

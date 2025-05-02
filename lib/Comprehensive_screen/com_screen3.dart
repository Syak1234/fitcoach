import 'dart:developer';

import 'package:fitcoach/Comprehensive_screen/com_screen4.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ruler_picker/ruler_picker.dart';

class ComScreen3 extends StatefulWidget {
  const ComScreen3({super.key});

  @override
  State<ComScreen3> createState() => _ComScreen3State();
}

class _ComScreen3State extends State<ComScreen3> {
  late RulerPickerController _rulerPickerController;
  num currentWeight = 70; // Default weight in Kg
  bool isKg = true; // Unit selection state

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentWeight);
  }

  Future<void> _savePreferences(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(type, currentWeight.toDouble());

    final a = prefs.getDouble(type) ?? '';
    log(a.toString());
  }

  void toggleUnit(bool toKg) {
    setState(() {
      if (toKg) {
        // Convert Lbs to Kg
        currentWeight = (currentWeight / 2.20462).round();
      } else {
        // Convert Kg to Lbs
        currentWeight = (currentWeight * 2.20462).round();
      }
      isKg = toKg;
      _rulerPickerController.value = currentWeight; // Update ruler picker
    });
  }

  Widget _buildToggleOption(String label, bool isLeft) {
    bool isSelected = (isLeft && isKg) || (!isLeft && !isKg);

    return Expanded(
      child: GestureDetector(
        onTap: () => toggleUnit(isLeft),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue60 : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Getx getx = Get.put(Getx());
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          SizedBox(height: 20),
          const Text(
            "What is your weight?",
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: AppFontSize.mediumfontSize,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              width: MediaQuery.sizeOf(context).width - 40,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.gray10,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _buildToggleOption("kg", true),
                  _buildToggleOption("lbs", false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: isKg ? 'kg' : 'lbs',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 123, 122, 122),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )
              ],
              text: "${currentWeight.toInt()}",
            ),
            style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 70,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: RulerPicker(
              rulerBackgroundColor: AppColors.textLight,
              controller: _rulerPickerController,
              onBuildRulerScaleText: (index, value) {
                return value.toInt().toString();
              },
              ranges: [
                isKg
                    ? RulerRange(begin: 20, end: 300, scale: 1) // Kg range
                    : RulerRange(begin: 44, end: 660, scale: 2), // Lbs range
              ],
              scaleLineStyleList: const [
                ScaleLineStyle(
                    color: AppColors.gray, width: 2.5, height: 30, scale: 0),
                ScaleLineStyle(
                    color: AppColors.gray, width: 2, height: 20, scale: 5),
                ScaleLineStyle(
                    color: AppColors.gray, width: 1.5, height: 10, scale: -1),
              ],
              onValueChanged: (value) {
                setState(() {
                  currentWeight = value;
                });
              },
              width: MediaQuery.of(context).size.width,
              rulerMarginTop: 100,
              rulerScaleTextStyle: TextStyle(
                  fontSize: 16,
                  color: AppColors.gray,
                  fontWeight: FontWeight.bold),
              marker: Container(
                width: 10,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryorange,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              height: 50,
            ),
          ),
          const SizedBox(height: 140),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: _buildContinueButton())
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backgroundDark,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      ),
      onPressed: () async {
        _savePreferences(isKg ? 'kg' : 'lbs');
        await SharedPrefHelper.setString(
            "weight", "${currentWeight.toInt()}${isKg ? 'kg' : 'lbs'}");

        Get.toNamed(
          AppRoutes.height,
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Continue",
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: AppColors.textLight),
        ],
      ),
    );
  }
}

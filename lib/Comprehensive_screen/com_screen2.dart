import 'package:fitcoach/Comprehensive_screen/com_screen3.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComScreen2 extends StatefulWidget {
  const ComScreen2({super.key});

  @override
  _ComScreen2State createState() => _ComScreen2State();
}

class _ComScreen2State extends State<ComScreen2> {
  String? selectedGender;
  // final Getx getx = Get.find<Getx>();

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Progress Bar

              Center(
                child: const Text(
                  "What is your gender?",
                  style: TextStyle(
                      fontSize: AppFontSize.mediumfontSize,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              _buildGenderOption("Male",
                  "assets/comprehensive/comprehensive1.png", Icons.male),
              const SizedBox(height: 12),
              _buildGenderOption("Female",
                  "assets/comprehensive/comprehensive2.png", Icons.female),
              const SizedBox(height: 50),
              // _buildSkipOption(),
              // const Spacer(),
              const SizedBox(height: 10),
              buildContinueButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, String imagePath, IconData icon) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              // color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primaryorange, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Image.asset(imagePath,
                        fit: BoxFit.cover, width: double.infinity, height: 150),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    // color: AppColors.gray10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Row(
                    children: [
                      Icon(icon, color: AppColors.textDark),
                      const SizedBox(width: 8),
                      Text(gender,
                          style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected ? AppColors.textDark : Color(0xFF646464),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSkipOption() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Prefer to skip, thanks!",
              style: TextStyle(color: AppColors.textLight)),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textLight),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildContinueButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backgroundDark,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      ),
      onPressed: selectedGender == null
          ? null
          : () {
              // getx.incresebarValue();
              Get.toNamed(
                AppRoutes.comScreen3,
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

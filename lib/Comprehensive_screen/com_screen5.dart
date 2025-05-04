import 'package:fitcoach/Comprehensive_screen/com_screen6.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComScreen5 extends StatefulWidget {
  @override
  State<ComScreen5> createState() => _ComScreen5State();
}

class _ComScreen5State extends State<ComScreen5> {
  Future<void> _savePreferences(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFitnessExp', type == "YES");
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Row: Back Button and Skip

              SizedBox(height: 20),
              // Progress Bar

              SizedBox(height: 40),
              // Question Text
              Center(
                child: Text(
                  'Do you have previous\nfitness experience?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/comprehensive/comprehensive3.png', // Replace with your image path
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Buttons Row: No and Yes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // No Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _savePreferences('No');
                        Get.toNamed(
                          AppRoutes.comScreen6,
                        );
                      }, // Add functionality for "No"
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gray10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.backgroundLight),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No',
                            style: TextStyle(
                              color: AppColors.gray,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.close, color: AppColors.gray),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Yes Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _savePreferences('YES');
                        Get.toNamed(
                          AppRoutes.comScreen6,
                        );
                      }, // Add functionality for "Yes"
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Yes',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.check, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

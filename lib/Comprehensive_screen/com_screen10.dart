import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/profile_screen/profile_screen1.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComScreen10 extends StatefulWidget {
  @override
  _ComScreen10State createState() => _ComScreen10State();
}

class _ComScreen10State extends State<ComScreen10> {
  String selectedOption = "Great";

  final List<Map<String, String>> sleepOptions = [
    {
      "label": "Excellent",
      "hours": ">8 hours",
      "icon": 'assets/comprehensive/icon6.png'
    },
    {
      "label": "Great",
      "hours": "7-8 hours",
      "icon": 'assets/comprehensive/icon7.png'
    },
    {
      "label": "Normal",
      "hours": "6-7 hours",
      "icon": 'assets/comprehensive/icon8.png'
    },
    {
      "label": "Bad",
      "hours": "3-4 hours",
      "icon": 'assets/comprehensive/icon9.png'
    },
    {
      "label": "Insomniac",
      "hours": "<2 hours",
      "icon": 'assets/comprehensive/icon10.png'
    },
  ];

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar & Skip

              SizedBox(
                height: 20,
              ),

              // Title
              Text(
                "What's your sleep quality like?",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: AppFontSize.mediumfontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32),

              // Sleep options
              Expanded(
                child: ListView.builder(
                  itemCount: sleepOptions.length,
                  itemBuilder: (context, index) {
                    final option = sleepOptions[index];
                    return _buildSleepOption(
                        option["label"]!,
                        option["hours"]!,
                        selectedOption == option["label"],
                        option['icon'].toString());
                  },
                ),
              ),

              // Continue button
              ElevatedButton(
                onPressed: () {
                  Get.to(() => ProfileScreen1(),
                      transition: Transition.rightToLeft);
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
      ),
    );
  }

  Widget _buildSleepOption(
      String label, String hours, bool isSelected, String icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = label;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryorange : AppColors.gray10,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.textLight : Colors.transparent,
            width: isSelected ? 1 : 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  icon,
                  width: 37,
                  height: 37,
                  color: isSelected ? AppColors.textLight : Colors.grey,
                ),
                // Icon(
                //   isSelected
                //       ? Icons.sentiment_satisfied
                //       : Icons.sentiment_neutral,
                //   color: isSelected ? Colors.orange : Colors.grey,
                // ),
                SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color:
                        isSelected ? AppColors.textLight : AppColors.textDark,
                    fontSize: 18,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: isSelected ? AppColors.textLight : Colors.grey,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  hours,
                  style: TextStyle(
                      color:
                          isSelected ? AppColors.textLight : AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

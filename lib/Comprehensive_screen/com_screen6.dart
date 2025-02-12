import 'package:fitcoach/Comprehensive_screen/com_screen7.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetxController/getx.dart';

class ComScreen6 extends StatefulWidget {
  @override
  _ComScreen6State createState() => _ComScreen6State();
}

class _ComScreen6State extends State<ComScreen6> {
  final List<Map<String, String>> diets = [
    {
      'title': 'Plant Based',
      'subtitle': 'Vegan',
      'icon': 'assets/comprehensive/icon1.png'
    },
    {
      'title': 'Carbo Diet',
      'subtitle': 'Bread, etc',
      'icon': 'assets/comprehensive/icon2.png'
    },
    {
      'title': 'Specialized',
      'subtitle': 'Paleo, keto, etc',
      'icon': 'assets/comprehensive/icon3.png'
    },
    {
      'title': 'Traditional',
      'subtitle': 'Fruit diet',
      'icon': 'assets/comprehensive/icon4.png'
    },
  ];
  String? selectedDiet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.textDark,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Row: Back Button and Skip

              SizedBox(height: 16),
              // Progress Bar

              // Question Text
              Center(
                child: Text(
                  'Do you have a specific\ndiet preference?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Responsive Diet Options
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: diets.map((diet) {
                      final isSelected = selectedDiet == diet['title'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDiet = diet['title'].toString();
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          height: 170,
                          // Adjust width to fit two items per row with spacing
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryorange
                                : AppColors.gray10,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Color.fromRGBO(103, 108, 117, 1),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    diet['title'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.textLight
                                          : AppColors.textDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    diet['subtitle'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.textLight
                                          : Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    diet['icon'].toString(),
                                    // size: 36,
                                    width: 14,
                                    height: 19,
                                    color: isSelected
                                        ? AppColors.textLight
                                        : Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // SizedBox(height: 16),
              // Continue Button
              ElevatedButton(
                onPressed: selectedDiet != null
                    ? () {
                        Get.to(() => ComScreen7(),
                            transition: Transition.rightToLeft);
                        // Add functionality here
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: AppColors.textLight),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GetxController/getx.dart';
import '../theme/font_Size.dart';

class ComScreen1 extends StatefulWidget {
  ComScreen1();

  @override
  State<ComScreen1> createState() => _ComScreen1State();
}

class _ComScreen1State extends State<ComScreen1> {
  final Getx getx = Get.put(Getx());
  final List<String> options = [
    "I wanna lose weight",
    "I wanna get bulks",
    "I wanna gain endurance",
    "Just trying out the app! 👍"
  ];

  Future<void> _saveSelection(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fitness_goal', options[index]);
    log(index.toString());
  }

  @override
  void initState() {
    _saveSelection(0);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textLight,
        elevation: 0,
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
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "What’s your fitness\ngoal/target?",
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              OptionTile(
                icon: Icons.monitor_weight,
                text: options[0],
                isSelected: getx.isCom_select_Option.value == 0,
                onTap: () {
                  getx.isCom_select_Option.value = 0;
                  _saveSelection(0);
                },
              ),
              OptionTile(
                icon: Icons.fitness_center,
                text: options[1],
                isSelected: getx.isCom_select_Option.value == 1,
                onTap: () {
                  getx.isCom_select_Option.value = 1;
                  _saveSelection(1);
                },
              ),
              OptionTile(
                icon: Icons.directions_run,
                text: options[2],
                isSelected: getx.isCom_select_Option.value == 2,
                onTap: () {
                  getx.isCom_select_Option.value = 2;
                  _saveSelection(2);
                },
              ),
              OptionTile(
                icon: Icons.emoji_emotions_outlined,
                text: options[3],
                isSelected: getx.isCom_select_Option.value == 3,
                onTap: () {
                  getx.isCom_select_Option.value = 3;
                  _saveSelection(3);
                },
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.comScreen2);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: AppColors.textLight),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryorange : AppColors.gray10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected
                ? AppColors.textLight
                : Color.fromARGB(255, 150, 149, 149),
          ),
          title: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.textLight : AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? AppColors.textLight : Color(0xFF646464),
          ),
        ),
      ),
    );
  }
}

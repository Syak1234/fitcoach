import 'package:fitcoach/Comprehensive_screen/com_screen10.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComScreen9 extends StatefulWidget {
  @override
  _ComScreen9State createState() => _ComScreen9State();
}

class _ComScreen9State extends State<ComScreen9> {
  var calorieGoal = 200.obs; // Observable calorie goal
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: calorieGoal.value.toString());

    // Update the text field when calorieGoal changes
    ever(calorieGoal, (value) {
      textController.text = value.toString();
    });
  }

  void increaseGoal() {
    calorieGoal.value = int.parse(textController.text);
    calorieGoal.value += 50;
  }

  void decreaseGoal() {
    if (calorieGoal.value > 0) {
      calorieGoal.value = int.parse(textController.text);
      calorieGoal.value -= 50;
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kcal_goal_perday', calorieGoal.value.toString());
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
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "What's Your Calorie Goal per day?",
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),

                // Calorie count
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/comprehensive/icon5.png',
                          width: 52,
                          height: 58,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 85,
                              fontWeight: FontWeight.bold,
                            ),
                            controller: textController,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        )
                      ],
                    ),
                    Text(
                      "calories daily",
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // Increment and decrement buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAdjustButton(
                      Icons.remove,
                      () {
                        decreaseGoal();
                      },
                      AppColors.gray10,
                      AppColors.gray,
                    ),
                    SizedBox(width: 16),
                    _buildAdjustButton(Icons.add, increaseGoal,
                        AppColors.primaryorange, AppColors.textLight),
                  ],
                ),

                SizedBox(height: 120),

                // Continue button
                ElevatedButton(
                  onPressed: () {
                    _savePreferences();
                    Get.toNamed(
                      AppRoutes.comScreen10,
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
        ),
      ),
    );
  }

  Widget _buildAdjustButton(
      IconData icon, VoidCallback onPressed, Color color, Color iconColor) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 112,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(21),
        ),
        padding: EdgeInsets.all(16),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}

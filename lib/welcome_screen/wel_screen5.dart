import 'package:fitcoach/signup_screen/login_screen.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'wel_screen4.dart';

class WelcomeScreen5 extends StatelessWidget {
  const WelcomeScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/fitness_app_img/welcome_screen5bg.png', // Ensure you have this image in the assets folder
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  "Nutrition & Diet\nGuidance",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle
                Text(
                  "Lose weight and get fit with Fitcoach! 🥗",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textLight.withOpacity(0.9),
                  ),
                ),

                const SizedBox(height: 40),

                // Navigation Buttons
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Button

                      IconButton(
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 70)),
                              shape: WidgetStatePropertyAll(
                                  ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              backgroundColor: WidgetStateColor.resolveWith(
                                (states) => AppColors.backgroundLight,
                              )),
                          // isSelected: true,

                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.textDark)),

                      // Right Button

                      IconButton(
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 70)),
                              shape: WidgetStatePropertyAll(
                                  ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(40))),
                              backgroundColor: WidgetStateColor.resolveWith(
                                (states) => AppColors.backgroundLight,
                              )),
                          // isSelected: true,

                          onPressed: () {
                            Get.to(() => SignInScreen(),
                                transition: Transition.rightToLeft);
                          },
                          icon: const Icon(Icons.arrow_forward,
                              color: AppColors.textDark)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

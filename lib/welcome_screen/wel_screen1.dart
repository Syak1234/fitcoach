import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/welcome_screen/wel_screen2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_routes.dart';

class WelcomeScreen1 extends StatelessWidget {
  const WelcomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/fitness_app_img/welcome_screen1bg.png', // Change to your asset image path
            fit: BoxFit.cover,
          ),

          // Black Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Foreground Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // Plus Icon
                // Container(
                //   padding: const EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: AppColors.textLight.withOpacity(0.9),
                //   ),
                //   child: const Icon(Icons.add, color: AppColors.textDark, size: 30),
                // ),

                const SizedBox(height: 20),

                // Welcome Text
                Text("Welcome To",
                    style: GoogleFonts.workSans(
                        textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ))),

                // App Name
                Text("Fitcoach!",
                    style: GoogleFonts.workSans(
                        textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ))),

                const SizedBox(height: 10),

                // Subtext
                Text(
                  "Your personal fitness Fitcoach 🏋️‍♂️",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight.withOpacity(0.70),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 80),

                // Get Started Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryorange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                  ),
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.welcomeScreen2,
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: AppColors.textLight),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Sign In Text
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have account? ",
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight.withOpacity(0.70)),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.login,
                            );
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                decoration: TextDecoration.overline,
                                decorationStyle: TextDecorationStyle.dashed,
                                fontSize: 14,
                                color: AppColors.primaryorange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

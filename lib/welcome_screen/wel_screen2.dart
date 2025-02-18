import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/welcome_screen/wel_screen3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/fitness_app_img/welcome_screen2bg.png', // Replace with your actual asset path
            fit: BoxFit.cover,
          ),

          SizedBox(
            height: 100,
          ),
          // Black Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Foreground UI
          Column(
            children: [
              const SizedBox(height: 40),

              // Progress Indicator
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 50),
              //   child: Container(
              //     height: 4,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.grey[400],
              //       borderRadius: BorderRadius.circular(2),
              //     ),
              //   ),
              // ),

              const Spacer(),

              // Main Text
              Text(
                "Personalized\nFitness Plans",
                textAlign: TextAlign.center,
                style: GoogleFonts.workSans(
                    textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                )),
              ),

              const SizedBox(height: 8),

              // Subtext
              Text(
                "Choose your own fitness journey with Fitcoach. 🏋️",
                textAlign: TextAlign.center,
                // style: ,
                style: GoogleFonts.workSans(
                    textStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                )),
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
                          Get.toNamed(
                            AppRoutes.welcomeScreen3,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward,
                            color: AppColors.textDark)),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

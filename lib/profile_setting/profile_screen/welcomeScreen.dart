import 'package:fitcoach/home_and_fitnessallUi/dashboard/dashboard_bottom.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home_and_fitnessallUi/dashboard/dashboard.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.textDark,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Welcome Text
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              children: [
                const Text(
                  'Hey Makise,',
                  style: TextStyle(
                    color: AppColors.backgroundDark,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome to the\nFitcoach!',
                  style: TextStyle(
                    color: AppColors.textDark,
                    //fontSize:AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaler: TextScaler.linear(3),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryorange,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.star, color: AppColors.textDark, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Pro Member',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          // Group Image
          Container(
            height: 245,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/profile/img6.png'),
                fit: BoxFit.contain,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          // Get Started Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            // color: AppColors.textDark,
            child: ElevatedButton(
              onPressed: () {
                Get.offAll(() => DashboardBottom());
                // Get.toNamed(
                //   AppRoutes.bottomDashboard,
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'OK, Let’s Get Started ',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    'assets/profile/img7.png',
                    width: 24,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:fitcoach/Firebase_functions/firebasefunctions.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CommunityScreen1 extends StatefulWidget {
  @override
  State<CommunityScreen1> createState() => _CommunityScreen1State();
}

class _CommunityScreen1State extends State<CommunityScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top image section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Image.asset(
                'assets/community_and_resource/community1.png', // Add your image here
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Fitness Community\n& Resources',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            const Text(
              'Connect, engage, and share insights with\ncoaches and fitness pals. ✨🤩',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            // Button

            buildExploreCommunityButton(context),
          ],
        ),
      ),
    );
  }
}

Widget buildExploreCommunityButton(BuildContext context) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryorange,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () async {
        await createUser(context, "150", "Sayak", "test1@gmail.com")
            .then((value) {
          if (value) {
            Get.toNamed(AppRoutes.commmunityScreen2);
          }
        });
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Explore Community',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: Colors.white)
        ],
      ),
    ),
  );
}

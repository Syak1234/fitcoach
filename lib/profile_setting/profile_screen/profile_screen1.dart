import 'dart:io';

import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/profile_setting/profile_screen/profile_screen2.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If needed for icons or vector images
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen1 extends StatefulWidget {
  @override
  _ProfileScreen1State createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
  final List<String> avatars = [
    "assets/profile/img1.png",
    "assets/profile/img2.png",
    "assets/profile/img3.png",
  ]; // Replace with your avatar image paths
  int selectedAvatarIndex = 1;
  RxString profilepath = ''.obs;
  void _pickLocalImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      // Check file size (in bytes)
      final fileSizeInBytes = await file.length();
      const maxFileSize = 5 * 1024 * 1024; // 5 MB in bytes

      if (fileSizeInBytes > maxFileSize) {
        // File is too large, show an error or handle it
        print("File size exceeds 5 MB. Please choose a smaller file.");
        return;
      }

      getx.profileImage.value = file;

      // If file size is valid, proceed
      final fileBytes = await file.readAsBytes();
      print("Picked file: ${pickedFile.path}");
      profilepath.value = pickedFile.path;

      // Add any additional actions like updating UI or uploading the file
    } else {
      print("No file selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          "Profile Setup",
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header

              SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: avatars.asMap().entries.map((entry) {
                  int index = entry.key;
                  String avatar = entry.value;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatarIndex = index;
                      });
                    },
                    child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 8.0),
                        // padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            // border: Border.all(color: index == selectedAvatarIndex
                            //     ? Colors.orange
                            //     : Colors.transparent,),
                            borderRadius: BorderRadius.circular(44.37)),
                        child: Image.asset(
                          avatar,
                          width: 115,
                        )
                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundImage: AssetImage(avatar),
                        // ),
                        ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 30,
              ),
              // Avatar Selection
              Text(
                "Select your Profile 👍",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "You can upload a profile locally.",
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32),

              // Avatar Carousel

              // Upload Option
              GestureDetector(
                onTap: _pickLocalImage,
                child: Container(
                  margin: EdgeInsets.only(top: 16.0),
                  // padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  // decoration: BoxDecoration(
                  //   color: Colors.grey.shade900,
                  //   borderRadius: BorderRadius.circular(12),
                  //   border: Border.all(
                  //     color: Colors.grey.shade700,
                  //     width: 1.5,
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      Obx(
                        () => profilepath.value != ''
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage: FileImage(File(
                                  profilepath.value,
                                )),
                              )
                            : Image.asset(
                                'assets/profile/img4.png',
                                width: 96,
                                color: AppColors.textDark,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Or Upload from Local File",
                        style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Max 5mb, Format: jpg, png",
                        style: TextStyle(
                            color: AppColors.gray,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 72),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildContinueButton(context),
              ),
              const SizedBox(height: 20),
              // Continue Button

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildContinueButton(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.backgroundDark,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
    ),
    onPressed: () {
      if (getx.userAssessmentDetaiils.length == 0) {
        getUserDetails().then((val) async {
          if (val == false) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            String fitnessGoal =
                await SharedPrefHelper.getString('fitness_goal') ?? "";
            String gender =
                await SharedPrefHelper.getString('selected_gender') ?? "";
            int height = await SharedPrefHelper.getInt('user_height_cm') ?? 0;
            String weight = await prefs.getString('weight') ?? "";

            bool previousFitnessExperience =
                await SharedPrefHelper.getBool('isFitnessExp') ?? false;
            String specificDiet =
                await SharedPrefHelper.getString('diet') ?? "";
            int daysCommit =
                await SharedPrefHelper.getInt('work_day_commit') ?? 0;
            List specificExperiencePreferance =
                await prefs.getStringList('excercise_pref') ?? [];
            String calorieyGoal =
                await SharedPrefHelper.getString('kcal_goal_perday') ?? "";
            String sleepQuality =
                await SharedPrefHelper.getString('sleep') ?? "";
            String age = await SharedPrefHelper.getString('age') ?? "";

            createUserDetails(
              context: context,
              userId: getx.userid.value,
              age: age,
              calorieyGoal: calorieyGoal,
              daysCommit: daysCommit,
              fitnessGoal: fitnessGoal,
              gender: gender,
              height: height,
              weight: weight,
              previousFitnessExperience: previousFitnessExperience,
              sleepQuality: sleepQuality,
              specificDiet: specificDiet,
              specificExperiencePreferance:
                  specificExperiencePreferance.toString(),
            );
          }
        });
      }

      Get.toNamed(
        AppRoutes.profileScreen2,
      );
    },
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Continue",
            style: TextStyle(
                color: AppColors.textLight,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        SizedBox(width: 8),
        Icon(Icons.arrow_forward, color: AppColors.textLight),
      ],
    ),
  );
}

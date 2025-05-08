import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen1.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/api/externalFunction.dart';
import 'package:fitcoach/forget_screen/forget_screen.dart';
import 'package:fitcoach/functionality/facebook_sign_auth.dart';
import 'package:fitcoach/modelClass/userDetails.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/signup_screen/signup_screen.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GetxController/getx.dart';
import '../functionality/google_signin_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService google_auth = AuthService();
  AuthServiceFacebook facebook_auth = AuthServiceFacebook();

  bool _passwordVisible = false;
  Getx getx = Get.put(Getx());
  User? user;
  Map<String, dynamic>? facebookdata = {};
  GlobalKey<FormState> gk = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(
                'assets/signup_img/signupbg.png',
                fit: BoxFit.cover,
                opacity: AlwaysStoppedAnimation(0.5),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.textLight.withValues(alpha: 0.1),
                      AppColors.textLight.withValues(alpha: 0.2),
                      AppColors.textLight,
                      AppColors.textLight,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: MediaQuery.of(context).size.height *
                      0.1, // Dynamic spacing
                ),
                child: Form(
                  key: gk,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 80),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.local_hospital,
                                color: AppColors.primaryorange, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Sign In To Fitcoach',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: AppFontSize.mediumfontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Let's personalize your fitness with Fitcoach",
                              style: TextStyle(
                                color: AppColors.grayOpacity,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 60),
                      Text(
                        'Email Address',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email Address',
                        icon: Icons.email,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Password',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock,
                        obscureText: !_passwordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.backgroundDark,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            // Userdetails userdetails =
                            //     Userdetails(email: ' ', name: ' ', userimg: ' ');

                            if (gk.currentState!.validate()) {
                              loginApi(context, _emailController.text,
                                      _passwordController.text, "Credentials")
                                  .then((val) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                String fitnessGoal =
                                    await SharedPrefHelper.getString(
                                            'fitness_goal') ??
                                        "";
                                String gender =
                                    await SharedPrefHelper.getString(
                                            'selected_gender') ??
                                        "";
                                int height = await SharedPrefHelper.getInt(
                                        'user_height_cm') ??
                                    0;
                                String weight =
                                    await prefs.getString('weight') ?? "";

                                bool previousFitnessExperience =
                                    await SharedPrefHelper.getBool(
                                            'isFitnessExp') ??
                                        false;
                                String specificDiet =
                                    await SharedPrefHelper.getString('diet') ??
                                        "";
                                int daysCommit = await SharedPrefHelper.getInt(
                                        'work_day_commit') ??
                                    0;
                                List specificExperiencePreferance = await prefs
                                        .getStringList('excercise_pref') ??
                                    [];
                                String calorieyGoal =
                                    await SharedPrefHelper.getString(
                                            'kcal_goal_perday') ??
                                        "";
                                String sleepQuality =
                                    await SharedPrefHelper.getString('sleep') ??
                                        "";
                                String age =
                                    await SharedPrefHelper.getString('age') ??
                                        "";
                                String userid =
                                    await SharedPrefHelper.getString(
                                            "userid") ??
                                        "";

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
                                  previousFitnessExperience:
                                      previousFitnessExperience,
                                  sleepQuality: sleepQuality,
                                  specificDiet: specificDiet,
                                  specificExperiencePreferance:
                                      specificExperiencePreferance.toString(),
                                );
                                // getUserDetails();
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward,
                                  color: AppColors.textLight),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //     decoration: BoxDecoration(
                          //         border: Border.all(
                          //             color: Colors.grey.withOpacity(0.4)),
                          //         // color: Colors.grey.withOpacity(0.3),
                          //         borderRadius: BorderRadius.circular(15)),
                          //     padding: EdgeInsets.all(12),
                          //     child: Image.asset(
                          //       'assets/signup_img/instagram_1384031.png',
                          //       width: 20,
                          //       color: AppColors.textDark,
                          //     )),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () async {
                              user = await google_auth.signInWithGoogle();

                              if (user!.email!.isNotEmpty) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                String fitnessGoal =
                                    await SharedPrefHelper.getString(
                                            'fitness_goal') ??
                                        "";
                                String gender =
                                    await SharedPrefHelper.getString(
                                            'selected_gender') ??
                                        "";
                                int height = await SharedPrefHelper.getInt(
                                        'user_height_cm') ??
                                    0;
                                String weight =
                                    await prefs.getString('weight') ?? "";

                                bool previousFitnessExperience =
                                    await SharedPrefHelper.getBool(
                                            'isFitnessExp') ??
                                        false;
                                String specificDiet =
                                    await SharedPrefHelper.getString('diet') ??
                                        "";
                                int daysCommit = await SharedPrefHelper.getInt(
                                        'work_day_commit') ??
                                    0;
                                List specificExperiencePreferance = await prefs
                                        .getStringList('excercise_pref') ??
                                    [];
                                String calorieyGoal =
                                    await SharedPrefHelper.getString(
                                            'kcal_goal_perday') ??
                                        "";
                                String sleepQuality =
                                    await SharedPrefHelper.getString('sleep') ??
                                        "";
                                String age =
                                    await SharedPrefHelper.getString('age') ??
                                        "";

                                checkEmailExistOrNot(
                                  user!.email.toString(),
                                  context,
                                ).then((val) {
                                  if (val) {
                                    loginApi(
                                            context,
                                            user!.email.toString(),
                                            passwordGanaretor(
                                              user!.email.toString(),
                                            ),
                                            "Google")
                                        .then((onValue) {
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
                                        previousFitnessExperience:
                                            previousFitnessExperience,
                                        sleepQuality: sleepQuality,
                                        specificDiet: specificDiet,
                                        specificExperiencePreferance:
                                            specificExperiencePreferance
                                                .toString(),
                                      );
                                    });
                                  } else {
                                    signUp(
                                            context,
                                            user!.email.toString(),
                                            passwordGanaretor(
                                              user!.email.toString(),
                                            ),
                                            "Google")
                                        .then((onValue) {
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
                                        previousFitnessExperience:
                                            previousFitnessExperience,
                                        sleepQuality: sleepQuality,
                                        specificDiet: specificDiet,
                                        specificExperiencePreferance:
                                            specificExperiencePreferance
                                                .toString(),
                                      );
                                    });
                                  }
                                });
                              }
                              // user!.email.toString();
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.4)),
                                    // color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.all(12),
                                child: Image.asset(
                                  'assets/signup_img/google.png',
                                  width: 20,
                                  // color: AppColors.textDark,
                                )),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () async {
                              // await facebook_auth.getFacebookUserData();
                              facebookdata = await facebook_auth
                                  .handleFacebookSignIn(context);

                              if (facebookdata != null) {
                                print("User Data: $facebookdata");
                                log(facebookdata!['picture']['data']['url']);

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                String fitnessGoal =
                                    await SharedPrefHelper.getString(
                                            'fitness_goal') ??
                                        "";
                                String gender =
                                    await SharedPrefHelper.getString(
                                            'selected_gender') ??
                                        "";
                                int height = await SharedPrefHelper.getInt(
                                        'user_height_cm') ??
                                    0;
                                String weight =
                                    await prefs.getString('weight') ?? "";

                                bool previousFitnessExperience =
                                    await SharedPrefHelper.getBool(
                                            'isFitnessExp') ??
                                        false;
                                String specificDiet =
                                    await SharedPrefHelper.getString('diet') ??
                                        "";
                                int daysCommit = await SharedPrefHelper.getInt(
                                        'work_day_commit') ??
                                    0;
                                List specificExperiencePreferance = await prefs
                                        .getStringList('excercise_pref') ??
                                    [];
                                String calorieyGoal =
                                    await SharedPrefHelper.getString(
                                            'kcal_goal_perday') ??
                                        "";
                                String sleepQuality =
                                    await SharedPrefHelper.getString('sleep') ??
                                        "";
                                String age =
                                    await SharedPrefHelper.getString('age') ??
                                        "";

                                checkEmailExistOrNot(
                                  facebookdata!['email'] ?? "",
                                  context,
                                ).then((val) {
                                  if (val) {
                                    loginApi(
                                            context,
                                            facebookdata!['email'] ?? "",
                                            passwordGanaretor(
                                              facebookdata!['email'] ?? "",
                                            ),
                                            "Facebook")
                                        .then((onValue) {
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
                                        previousFitnessExperience:
                                            previousFitnessExperience,
                                        sleepQuality: sleepQuality,
                                        specificDiet: specificDiet,
                                        specificExperiencePreferance:
                                            specificExperiencePreferance
                                                .toString(),
                                      );
                                    });
                                  } else {
                                    signUp(
                                            context,
                                            facebookdata!['email'] ?? "",
                                            passwordGanaretor(
                                              facebookdata!['email'] ?? "",
                                            ),
                                            "Facebook")
                                        .then((onValue) {
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
                                        previousFitnessExperience:
                                            previousFitnessExperience,
                                        sleepQuality: sleepQuality,
                                        specificDiet: specificDiet,
                                        specificExperiencePreferance:
                                            specificExperiencePreferance
                                                .toString(),
                                      );
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.4)),
                                    // color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.all(12),
                                child: Image.asset(
                                  'assets/signup_img/facebook.png',
                                  width: 20,
                                  // color: AppColors.textDark,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.signup,
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryorange,
                                    color: AppColors.primaryorange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.forgetpasword,
                            );
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryorange,
                              color: AppColors.primaryorange,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    Color borderColor = AppColors.primaryorange,
  }) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Can't be blank";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textDark),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.gray10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}

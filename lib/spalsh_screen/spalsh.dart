import 'dart:developer';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/welcome_screen/wel_screen1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Spalsh extends StatefulWidget {
  const Spalsh({super.key});

  @override
  State<Spalsh> createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  // @override
  // void initState() {
  //   super.initState();

  //   // Navigate to next page after 3 seconds

  // }

  late SharedPreferences sp;
  final LocalAuthentication _localAuth = LocalAuthentication();
  // bool _isBiometricAvailable = false;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    Future.delayed(const Duration(seconds: 3), () async {
      final isAuthentication = await Getx().isBioMatricEnable();
      log(isAuthentication.toString());
      if (isAuthentication) {
        _authenticateWithFingerprint();
      } else {
        // Get.off(() => WelcomeScreen1());
        Get.offNamed(
          AppRoutes.welcomeScreen1,
        );
      }
    });
  }

  Future<void> _authenticateWithFingerprint() async {
    try {
      // SharedPreferences sp = await SharedPreferences.getInstance();
      bool authenticated = await Getx().authBioMatric();

      authenticated
          ? Get.toNamed(AppRoutes.login)
          : Get.toNamed(AppRoutes.welcomeScreen1);
    } catch (e) {
      Get.toNamed(AppRoutes.welcomeScreen1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/fitness_app_img/splash_screen_bg.png',
              ),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize:MainAxisSize.max ,
          children: [
            Spacer(),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(90),
                  color: AppColors.textDark,
                ),

                // padding: EdgeInsets.only(bottom: 60),
                child: Image.asset(
                  'assets/fitness_app_img/splash_qutetion.png',
                  width: 64,

                  // colorBlendMode: BlendMode.color,
                  // color: ,
                ),
              ),
            ),
            SizedBox(
              height: 58,
            ),
            Row(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width - 5,
                    child: Text(
                      '"Remember, physical fitness can neither be acquired by wishful thinking nor by outright purchase.”',
                      style: GoogleFonts.workSans(
                          textStyle: TextStyle(
                              color: AppColors.textLight, fontSize: 24)),

                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 52,
            ),
            Row(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width - 5,
                    child: Text(
                      '— Joseph Pilates'.toUpperCase(),
                      style: GoogleFonts.workSans(
                          textStyle: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      // style: TextStyle(color: AppColors.textDark, fontSize: 14),
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}

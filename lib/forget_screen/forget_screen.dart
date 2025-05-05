import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  Getx getx = Get.put(Getx());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark),
            onPressed: () {
              getx.sendVia2fa.value = false;
              getx.sendViaEmail.value = false;
              getx.sendViagoogle.value = false;

              Get.back();
            },
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/signup_img/forgetbg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent, Colors.transparent,
                      // AppColors.textDark,
                      // AppColors.textDark,
                      Colors.white.withOpacity(0.4),
                    ],
                    // begin: Alignment.bottomCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Reset Password",
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Select what method you’d like to reset.",
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 30),
                    Obx(
                      () => InkWell(
                        onTap: () {
                          getx.sendVia2fa.value = false;
                          getx.sendViaEmail.value = true;
                          getx.sendViagoogle.value = false;
                        },
                        child: _buildOption(
                            icon: Icons.email,
                            title: "Send via Email",
                            description:
                                "Seamlessly reset your password via email address.",
                            color: AppColors.primaryorange,
                            isSelected: getx.sendViaEmail.value),
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => InkWell(
                        onTap: () {
                          getx.sendVia2fa.value = true;
                          getx.sendViaEmail.value = false;
                          getx.sendViagoogle.value = false;
                        },
                        child: _buildOption(
                            icon: Icons.lock,
                            title: "Send via 2FA",
                            description:
                                "Seamlessly reset your password via 2 Factors.",
                            color: Color.fromRGBO(37, 99, 235, 1),
                            isSelected: getx.sendVia2fa.value),
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => InkWell(
                        onTap: () {
                          getx.sendVia2fa.value = false;
                          getx.sendViaEmail.value = false;
                          getx.sendViagoogle.value = true;
                        },
                        child: _buildOption(
                            icon: Icons.security,
                            title: "Send via Google Auth",
                            description:
                                "Seamlessly reset your password via gAuth.",
                            color: Color.fromRGBO(147, 51, 234, 1),
                            isSelected: getx.sendViagoogle.value),
                      ),
                    ),
                    // Spacer()
                    //
                    // ,
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !getx.sendVia2fa.value &&
                                    !getx.sendViaEmail.value &&
                                    !getx.sendViagoogle.value
                                ? AppColors.gray10
                                : AppColors.backgroundDark,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            if (!getx.sendVia2fa.value &&
                                !getx.sendViaEmail.value &&
                                !getx.sendViagoogle.value) {
                              Fluttertoast.showToast(msg: "No option choosen!");
                            }

                            if (getx.sendVia2fa.value) {
                              Fluttertoast.showToast(
                                  msg: "Currently not available!");
                            }
                            if (getx.sendViaEmail.value) {
                              Get.toNamed(
                                  AppRoutes.requestEmailOtpForForgetPassword);
                            }
                            if (getx.sendViagoogle.value) {
                              Fluttertoast.showToast(
                                  msg: "Currently not available!");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: !getx.sendVia2fa.value &&
                                          !getx.sendViaEmail.value &&
                                          !getx.sendViagoogle.value
                                      ? AppColors.gray
                                      : AppColors.textLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward,
                                  color: !getx.sendVia2fa.value &&
                                          !getx.sendViaEmail.value &&
                                          !getx.sendViagoogle.value
                                      ? AppColors.gray
                                      : AppColors.textLight),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
      {required IconData icon,
      required String title,
      required String description,
      required Color color,
      required bool isSelected}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust padding or text size based on width constraints.
        double iconSize = constraints.maxWidth > 400 ? 32 : 24;
        double paddingSize = constraints.maxWidth > 400 ? 24 : 16;

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
                color:
                    isSelected ? AppColors.primaryorange : Colors.transparent,
                width: 2),
            color: AppColors.gray10,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(paddingSize),
          child: Row(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(21),
                ),
                // padding: EdgeInsets.all(15),
                child: Icon(icon, color: AppColors.textLight, size: iconSize),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: constraints.maxWidth > 400 ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                          color: AppColors.gray,
                          fontSize: constraints.maxWidth > 400 ? 14 : 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: AppColors.textDark.withOpacity(0.54),
                  size: iconSize - 4),
            ],
          ),
        );
      },
    );
  }
}

import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  var obscureText = true.obs;
  var password = ''.obs;
  var strength = 0.0.obs;
  var hasNumber = false.obs;
  var hasSymbol = false.obs;
  var hasAlphabet = false.obs;

  void checkPassword(String value) {
    password.value = value;
    hasNumber.value = value.contains(RegExp(r'[0-9]'));
    hasAlphabet.value = value.contains(RegExp(r'[A-Z]'));
    hasSymbol.value = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    if (hasNumber.value &&
        hasAlphabet.value &&
        hasSymbol.value &&
        value.length >= 6) {
      strength.value = 1;
    } else if (value.length >= 4) {
      strength.value = 0.3;
    } else {
      strength.value = 0.1;
    }
  }

  Color get strengthColor {
    if (strength.value == 1) return Colors.green;
    if (strength.value >= 0.3) return Colors.orange;
    return Colors.red;
  }

  String get strengthText {
    if (strength.value == 1) return "Strong 💪";
    if (strength.value >= 0.3) return "Weak!! Increase strength 💪";
    return "Weak!! Increase strength 💪";
  }
}

class PasswordScreen extends StatelessWidget {
  final controller = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 25),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Let’s Set Up Your \nPassword.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Obx(() => TextField(
                    obscureText: controller.obscureText.value,
                    onChanged: controller.checkPassword,
                    controller: SearchController(),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(
                          color: AppColors.primaryorange,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: AppColors.primaryorange,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.primaryorange,
                          width: 2,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: InkWell(
                          onTap: () {
                            controller.obscureText.value =
                                !controller.obscureText.value;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: const Color.fromARGB(255, 217, 217, 220),
                            ),
                            padding: EdgeInsets.all(13),

                            // margin: EdgeInsets.all(5),
                            child: Icon(
                              controller.obscureText.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.gray80,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password Strength",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Obx(() => LinearProgressIndicator(
                    value: controller.strength.value,
                    backgroundColor: Colors.grey[300],
                    color: controller.strengthColor,
                    minHeight: 8,
                  )),
              SizedBox(height: 10),
              Obx(() => Text(
                    controller.strengthText,
                    style: TextStyle(color: Colors.black54),
                  )),
              SizedBox(height: 20),
              Obx(() => Column(
                    children: [
                      if (!controller.hasNumber.value)
                        _buildWarning("Must Have 0-9 unique numbers!"),
                      if (!controller.hasAlphabet.value)
                        _buildWarning("Must have A-Z alphabeticals!"),
                      if (!controller.hasSymbol.value)
                        _buildWarning("Must have a spacial character!"),
                    ],
                  )),
              SizedBox(height: 30),
              Obx(() => ElevatedButton(
                    onPressed: (controller.hasNumber.value &&
                            controller.hasSymbol.value &&
                            controller.hasAlphabet.value &&
                            controller.password.value.length >= 6)
                        ? () async {
                            await resetPassword(context,
                                    email: getx.emailFP.value,
                                    otp: getx.otpFP.value,
                                    newPassword: controller.password.value)
                                .then((val) {
                              if (val) {
                                Get.toNamed(AppRoutes.login);
                              }
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundDark,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Continue',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.textLight)),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: AppColors.textLight,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarning(String text) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

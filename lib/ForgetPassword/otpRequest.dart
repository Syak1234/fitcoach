import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OTPRequestScreen extends StatefulWidget {
  const OTPRequestScreen({super.key});

  @override
  State<OTPRequestScreen> createState() => _OTPRequestScreenState();
}

class _OTPRequestScreenState extends State<OTPRequestScreen> {
  TextEditingController emailFeildController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios,
                            size: 24, color: Colors.black)),
                    SizedBox(width: 10),
                    Text(
                      'OTP Setup',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/ForgetPassword/lock.png',
                height: 300,
              ),
              const SizedBox(height: 10),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'We will send a one time SMS message.\nCarrier rates may apply!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.primaryorange, width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.gray10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Icon(Icons.email_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: emailFeildController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your Email',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: emailFeildController.text));
                            Fluttertoast.showToast(msg: "email copied!");
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 13),
                            child: Icon(Icons.copy, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (emailFeildController.text.contains("@")) {
                        Get.toNamed(AppRoutes.otpConfirmPage);

                        // genarateFPcode(context,
                        //         email: emailFeildController.text)
                        //     .then((val) {
                        //   if (val) {
                        //     Get.toNamed(AppRoutes.otpConfirmPage);
                        //   } else {
                        //     Fluttertoast.showToast(msg: "Failed!!");
                        //   }
                        // });
                      } else {
                        Fluttertoast.showToast(msg: "Enter a valid email!");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Send OTP',
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

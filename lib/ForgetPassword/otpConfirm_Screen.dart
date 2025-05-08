import 'dart:async';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OTPConfirmationPage extends StatefulWidget {
  @override
  _OTPConfirmationPageState createState() => _OTPConfirmationPageState();
}

class _OTPConfirmationPageState extends State<OTPConfirmationPage> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());
  RxBool invalidOTP = false.obs;
  int focusedIndex = 0;

  RxInt secondsRemaining = 60.obs;
  late Timer _timer;

  Getx getx = Get.put(Getx());
  @override
  void initState() {
    super.initState();
    startTimer();
    // Set listeners to track focus changes
    for (int i = 0; i < 4; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            focusedIndex = i;
          });
        }
      });
    }
    // Request initial focus on the first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  void startTimer() {
    secondsRemaining.value = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((c) => c.dispose());
    _focusNodes.forEach((f) => f.dispose());
    _timer.cancel();

    super.dispose();
  }

  Widget buildOTPField(int index) {
    bool isFocused = focusedIndex == index;
    return Container(
      width: 50,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isFocused ? AppColors.gray : AppColors.gray80,
        ),
        color: isFocused ? Colors.orange : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isFocused ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: "0",
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios,
                            size: 24, color: Colors.black)),
                    SizedBox(width: 10),
                    Text(
                      'OTP Confirmation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: IconButton(
              //     icon: Icon(Icons.arrow_back),
              //     onPressed: () {},
              //   ),
              // ),
              // SizedBox(height: 20),
              // Text(
              //   'OTP Confirmation',
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              SizedBox(height: 70),
              Text(
                'Enter 4 digit OTP Code!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please enter the four digit OTP code we\nsent to your phone! 🙏',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    overflow: TextOverflow.ellipsis),
              ),
              SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) => buildOTPField(index)),
                ),
              ),
              SizedBox(height: 20),

              Obx(
                () => Visibility(
                  visible: invalidOTP.value,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Invalid OTP Code! Try again.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String enteredOTP = _controllers.map((c) => c.text).join();
                    if (enteredOTP.length < 4) {
                      invalidOTP.value = true;
                    } else {
                      getx.otpFP.value = enteredOTP;
                      invalidOTP.value = false;
                      Get.toNamed(AppRoutes.resetPassword);
                    }
                    // Here you can validate the OTP
                    print('Entered OTP: $enteredOTP');
                  },
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
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Spacer(),
              Obx(() {
                if (secondsRemaining.value > 0) {
                  return Text(
                    "Resend code in 0:${secondsRemaining.value.toString().padLeft(2, '0')}",
                    style: TextStyle(color: Colors.grey[600]),
                  );
                } else {
                  return TextButton(
                    onPressed: () {
                      genarateFPcode(context, email: getx.emailFP.value);
                      // Trigger resend logic here
                      startTimer();
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Didn’t receive your OTP? ",
                        style: TextStyle(color: Colors.grey[600]),
                        children: [
                          TextSpan(
                            text: 'Send again',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryorange,
                              color: AppColors.primaryorange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

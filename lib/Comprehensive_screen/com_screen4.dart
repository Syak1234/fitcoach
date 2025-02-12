import 'package:fitcoach/Comprehensive_screen/com_screen5.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';

class ComScreen4 extends StatefulWidget {
  @override
  _ComScreen4State createState() => _ComScreen4State();
}

class _ComScreen4State extends State<ComScreen4> {
  final daysOfWeek = List.generate(120, (index) => index + 1);
// print(daysOfWeek);

  int selectedIndex = 15; // Keeps track of the selected index

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 50.0,
      height: 3,
      fontWeight: FontWeight.bold,
      // fontStyle: FontStyle
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textLight,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Assessment",
          style: TextStyle(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Skip",
                style: TextStyle(color: AppColors.textLight),
              ),
            ),
          ),
        ],
      ),
      // backgroundColor:,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              // Progress Bar

              SizedBox(height: 40),
              Center(
                child: Text(
                  'What is your age?',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: AppFontSize.mediumfontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 450,
                child: Center(
                  child: WheelPicker(
                    style: WheelPickerStyle(
                      itemExtent: textStyle.fontSize! * textStyle.height!,
                      squeeze: 1.25,
                      shiftAnimationStyle: const WheelShiftAnimationStyle(
                        duration: Duration(seconds: 1),
                        curve: Curves.bounceOut,
                      ),
                    ),
                    itemCount: daysOfWeek.length,
                    onIndexChanged: (index, interactionType) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    initialIndex: selectedIndex,
                    builder: (context, index) => Container(
                      width: MediaQuery.sizeOf(context).width - 100,
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? AppColors.primaryorange
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(48),
                        border: Border.all(
                          color: selectedIndex == index
                              ? AppColors.textLight
                              : Colors.transparent,
                          width: selectedIndex == index ? 0.5 : 0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          daysOfWeek[index].toString(),
                          // textScaler: TextScaler.linear(),
                          style: textStyle.copyWith(
                            color: selectedIndex == index
                                ? AppColors.textLight
                                : const Color.fromARGB(255, 100, 100, 100),
                          ),
                        ),
                      ),
                    ),
                    looping: false,
                  ),
                ),
              ),
              SizedBox(height: 40),
              _buildContinueButton(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildContinueButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.backgroundDark,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
    ),
    onPressed: () {
      Get.to(() => ComScreen5(), transition: Transition.rightToLeft);
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

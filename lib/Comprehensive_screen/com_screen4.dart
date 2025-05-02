import 'package:fitcoach/Comprehensive_screen/com_screen5.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_picker/wheel_picker.dart';

class ComScreen4 extends StatefulWidget {
  @override
  _ComScreen4State createState() => _ComScreen4State();
}

class _ComScreen4State extends State<ComScreen4> {
  final daysOfWeek = List.generate(120, (index) => index + 1);
  int selectedIndex = 15; // Keeps track of the selected index

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('age', selectedIndex.toString());

    // final a = prefs.getDouble(type) ?? '';
    // log(a.toString());
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 50.0,
      height: 3,
      fontWeight: FontWeight.bold,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
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
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                _buildContinueButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () async {
        _savePreferences();

        Get.toNamed(
          AppRoutes.comScreen5,
        );
        // Get.to(() => ProfileScreen1(),
        //     transition: Transition.rightToLeft);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backgroundDark,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Continue",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: AppColors.textLight),
        ],
      ),
    );
  }
}

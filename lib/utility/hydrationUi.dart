import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/utility/step_trackerUi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'hydration_controller.dart';
// hydration_controller.dart
import 'package:get/get.dart';

class HydrationScreen extends StatelessWidget {
  final StepsController controller = Get.put(StepsController());
  final TextEditingController waterInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // fetch once

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: screenHeight * 0.02),
            Obx(() => _buildWaterText(controller.totalIntake.value)),
            SizedBox(height: 10),
            Obx(() => Text(
                  "You need ${controller.dailyGoal.value - controller.totalIntake.value}ml for today.",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.gray,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(height: screenHeight * 0.05),
            Expanded(child: _buildStackedSection(screenHeight, screenWidth)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(Icons.arrow_back_ios_new, ontap: () => Get.back()),
          Text("Hydration",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          _iconButton(Icons.settings),
        ],
      ),
    );
  }

  Widget _buildWaterText(int value) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.water_drop, color: AppColors.blue60, size: 24),
          ),
          TextSpan(
            text: " $value",
            style:
                GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: " ml",
            style: TextStyle(
                fontSize: 24,
                color: AppColors.gray,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedSection(double screenHeight, double screenWidth) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: screenHeight * 0.3,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: AppColors.gray10,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.all(16),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Goal",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.grey.shade600)),
                    Text("${controller.dailyGoal.value}ml",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                )),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            child: Container(
              height: 232,
              width: screenWidth,
              color: AppColors.blue60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Current",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textLight)),
                  Obx(() => Text(
                        "${controller.totalIntake.value}ml",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight),
                      )),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      padding: EdgeInsets.all(20),
                      backgroundColor: AppColors.textLight,
                    ),
                    onPressed: () {
                      _showAddWaterDialog();
                    },
                    child: Icon(Icons.add, size: 30, color: AppColors.blue60),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddWaterDialog() {
    Get.defaultDialog(
      titlePadding: EdgeInsets.only(top: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      backgroundColor: Colors.white,
      radius: 16,
      title: "Add Water Intake",
      titleStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.blue60,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: waterInputController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter amount in ml",
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              filled: true,
              fillColor: AppColors.gray10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.water_drop, color: AppColors.blue60),
            ),
            style: GoogleFonts.poppins(),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue60,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final amount = int.tryParse(waterInputController.text);
                if (amount != null && amount > 0) {
                  Get.back();
                  String userid =
                      await SharedPrefHelper.getString('userid') ?? '';
                  // updateData(userId: userid, date: DateTime.now().toIso8601String(), water:int.parse( waterInputController.text), step: controller.ste, minutes: minutes, km: km, kcal: kcal, id: id)
                }
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                "Add",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, {void Function()? ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textLight,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(8),
        child: Icon(icon, size: 24, color: AppColors.textDark),
      ),
    );
  }
}

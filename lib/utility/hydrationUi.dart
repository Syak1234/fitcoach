import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HydrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconButton(
                    Icons.arrow_back_ios_new,
                    ontap: () {
                      Get.back();
                    },
                  ),
                  Text(
                    "Hydration",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _iconButton(Icons.settings),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.water_drop,
                        color: AppColors.blue60, size: 24),
                  ),
                  TextSpan(
                    text: " 500",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
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
            ),
            SizedBox(height: 10),
            Text(
              "You need 1500ml for today.",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.gray,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.05),
            Expanded(
              child: Stack(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Goal",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey.shade600),
                          ),
                          Text(
                            "2000ml",
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                      child: Container(
                        height: 232,
                        width: screenWidth,
                        color: AppColors.blue60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Current",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: AppColors.textLight),
                            ),
                            Text(
                              "500ml",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textLight),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  // side: BorderSide(),
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(32)),
                                  padding: EdgeInsets.all(20),
                                  backgroundColor: AppColors.textLight),
                              onPressed: () {},
                              child: Icon(Icons.add,
                                  size: 30, color: AppColors.blue60),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

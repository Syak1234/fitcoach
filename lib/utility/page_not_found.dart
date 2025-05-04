import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../GetxController/getx.dart';

class NotFoundScreen extends StatelessWidget {
  // Getx getx = Get.put(Getx());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back Button
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: IconButton(
            //       icon: Icon(Icons.arrow_back, color: Colors.white),
            //       onPressed: () => Navigator.pop(context),
            //     ),
            //   ),
            // ),

            // Image
            Expanded(
              child:
                  Image.asset('assets/utility/pagenot_found.png', height: 200),
            ),

            // Not Found Text
            Text(
              "Not Found",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSize.mediumfontSize,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Whoops! can’t find",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),

            SizedBox(height: 16),

            // Status Code Badge
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.red.shade900,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(Icons.error_outline, color: Colors.white, size: 18),
            //       SizedBox(width: 6),
            //       Text(
            //         "Status Code: 404",
            //         style: GoogleFonts.poppins(color: Colors.white),
            //       ),
            //     ],
            //   ),
            // ),

            SizedBox(height: 32),

            // Home Button
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 32),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: AppColors.primaryorange,
            //         padding: EdgeInsets.symmetric(vertical: 16),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(19),
            //         ),
            //       ),
            //       onPressed: () {
            //         // Navigate to Home
            //       },
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             "Take Me Home",
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 18),
            //           ),
            //           SizedBox(width: 8),
            //           Icon(Icons.home, color: Colors.white),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

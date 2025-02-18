import 'package:fitcoach/constant.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {},
                  ),
                  Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      // decoration: BoxDecoration(
                      //   color: Colors.orange,
                      //   shape: BoxShape.circle,
                      // ),
                      child: Image.asset(
                        Constant.appLogo,
                        width: 96,
                        height: 96,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Fitcoach",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Fitness Solution",
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textDark.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 141,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: AppColors.textDark.withOpacity(0.6)),
                        SizedBox(width: 8),
                        Text(
                          "Address",
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "578 Boolean Ave\nTuring St\nNew York, NY",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grayOpacity.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 141,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone,
                            color: AppColors.textDark.withOpacity(0.6)),
                        SizedBox(width: 8),
                        Text(
                          "Telephone",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "+123-456-789\n+44-887-449",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grayOpacity.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Spacer(),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.facebook, color: AppColors.gray),
                  // SizedBox(width: 10),
                  // Icon(Icons.camera_alt, color: Colors.grey[500]),
                  // SizedBox(width: 10),
                  // Icon(Icons.business, color: Colors.grey[500]),
                  // SizedBox(width: 10),
                  // Icon(Icons.play_arrow, color: Colors.grey[500]),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

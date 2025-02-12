import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

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
                  _buildOption(
                    icon: Icons.email,
                    title: "Send via Email",
                    description:
                        "Seamlessly reset your password via email address.",
                    color: AppColors.primaryorange,
                  ),
                  SizedBox(height: 16),
                  _buildOption(
                    icon: Icons.lock,
                    title: "Send via 2FA",
                    description:
                        "Seamlessly reset your password via 2 Factors.",
                    color: Color.fromRGBO(37, 99, 235, 1),
                  ),
                  SizedBox(height: 16),
                  _buildOption(
                    icon: Icons.security,
                    title: "Send via Google Auth",
                    description: "Seamlessly reset your password via gAuth.",
                    color: Color.fromRGBO(147, 51, 234, 1),
                  ),
                  // Spacer()
                  //
                  // ,
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundDark,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Reset Password',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust padding or text size based on width constraints.
        double iconSize = constraints.maxWidth > 400 ? 32 : 24;
        double paddingSize = constraints.maxWidth > 400 ? 24 : 16;

        return Container(
          decoration: BoxDecoration(
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

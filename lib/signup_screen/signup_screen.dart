import 'package:fitcoach/signup_screen/login_screen.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _passwordsMatch = true;

  void _checkPasswords() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove default background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(
                'assets/signup_img/signupbg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.textLight.withValues(alpha: 0.1),
                      AppColors.textLight.withValues(alpha: 0.2),
                      AppColors.textLight,
                      AppColors.textLight,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: MediaQuery.of(context).size.height *
                      0.1, // Dynamic spacing
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.local_hospital,
                              color: AppColors.primaryorange, size: 40),
                          SizedBox(height: 10),
                          Text(
                            'Sign Up For Free',
                            style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: AppFontSize.mediumfontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Quickly make your account in 1 minute',
                            style: TextStyle(
                                color: AppColors.grayOpacity, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 60),
                    Row(
                      children: [
                        Text(
                          'Email Address',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _buildTextField(
                        controller: _emailController,
                        hintText: 'Email Address',
                        icon: Icons.email),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock,
                      obscureText: !_passwordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey),
                        onPressed: () => setState(
                            () => _passwordVisible = !_passwordVisible),
                      ),
                      onChanged: (_) => _checkPasswords(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      icon: Icons.lock,
                      obscureText: !_confirmPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey),
                        onPressed: () => setState(() =>
                            _confirmPasswordVisible = !_confirmPasswordVisible),
                      ),
                      borderColor: _passwordsMatch ? Colors.grey : Colors.red,
                      onChanged: (_) => _checkPasswords(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (!_passwordsMatch)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: AppColors.red10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: AppColors.red, size: 20),
                              SizedBox(width: 10),
                              Text('ERROR: Passwords Don\'t Match!',
                                  style: TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
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
                            Text('Sign Up',
                                style: TextStyle(
                                    color: AppColors.textLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward,
                                color: AppColors.textLight),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.off(() => SignInScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 141, 139, 139)),
                            children: [
                              TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    color: AppColors.primaryorange,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    Color borderColor = AppColors.primaryorange,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textDark.withOpacity(0.70)),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.gray10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}

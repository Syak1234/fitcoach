import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/profile_setting/profile_screen/welcomeScreen.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintSetup extends StatefulWidget {
  const FingerprintSetup({Key? key}) : super(key: key);

  @override
  State<FingerprintSetup> createState() => _FingerprintSetupState();
}

class _FingerprintSetupState extends State<FingerprintSetup> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  String _authMessage = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  // Check if biometric authentication is available
  Future<void> _checkBiometricSupport() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      setState(() {
        _isBiometricAvailable = canCheckBiometrics;
      });
    } catch (e) {
      setState(() {
        _authMessage = 'Error checking biometrics: $e';
      });
    }
  }

  // Authenticate using biometrics
  Future<void> _authenticateWithFingerprint() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to proceed.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _authMessage = authenticated
            ? 'Authentication successful!'
            : 'Authentication failed!';
      });
      Get.toNamed(
        AppRoutes.welcomeScreen,
      );
    } catch (e) {
      setState(() {
        _authMessage = 'Authentication error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.textDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            // Go back
            Get.back();
          },
        ),
        title: const Text(
          'Fingerprint',
          style: TextStyle(color: AppColors.textDark, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Fingerprint Setup 👆',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: AppFontSize.mediumfontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Scan your biometric fingerprint to make your account more secure!',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Fingerprint Scanner Illustration

            Image.asset(
              'assets/profile/img5.jpg',

              // color: AppColors.backgroundDark,
            ),
            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     Container(
            //       height: 200,
            //       width: 200,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(100),
            //         gradient: const LinearGradient(
            //           colors: [AppColors.textDark, Colors.orange],
            //           stops: [0.8, 1],
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //         ),
            //       ),
            //       child: const Center(
            //         child: Icon(
            //           Icons.fingerprint,
            //           size: 120,
            //           color: AppColors.textDark,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 20),
            if (_authMessage != '')
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: _authMessage == 'Authentication successful!'
                        ? Colors.green
                        : Colors.red.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: AppColors.textDark, size: 20),
                      SizedBox(width: 10),
                      Text(_authMessage,
                          style: TextStyle(color: AppColors.textLight)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 40),

            // Scan Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange10,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21)),
              ),
              onPressed: () {
                Get.toNamed(
                  AppRoutes.welcomeScreen,
                );
                // Skip functionality
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Skip, thanks',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryorange,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.close,
                    color: AppColors.primaryorange,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundDark,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21)),
              ),
              onPressed:
                  _isBiometricAvailable ? _authenticateWithFingerprint : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ok, let\'s scan',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: AppColors.textLight),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

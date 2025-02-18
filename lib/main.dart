// import 'package:fitcoach/Comprehensive_screen/com_screen1.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:fitcoach/Comprehensive_screen/com_screen4.dart';
// import 'package:fitcoach/Comprehensive_screen/com_screen1.dart';
// import 'package:fitcoach/Comprehensive_screen/com_screen10.dart';
// import 'package:fitcoach/Comprehensive_screen/com_screen2.dart';
// import 'package:fitcoach/Comprehensive_screen/com_screen3.dart';
// import 'package:fitcoach/Comprehensive_screen/com_screen5.dart';
// import 'package:fitcoach/Comprehensive_screen/com_screen6.dart';
// import 'package:fitcoach/Comprehensive_screen/com_screen9.dart';
// import 'package:fitcoach/profile_screen/finger_print_setup.dart';
// import 'package:fitcoach/profile_screen/profile_screen1.dart';
// import 'package:fitcoach/profile_screen/profile_screen1.dart';
// import 'package:fitcoach/profile_screen/profile_screen2.dart';
// import 'package:fitcoach/GetxController/getx.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitcoach/Comprehensive_screen/heightUi.dart';

import 'package:fitcoach/profile_setting/account_setting/linked_device.dart';
import 'package:fitcoach/profile_setting/notification/notificationUi.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/spalsh_screen/spalsh.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/utility/step_trackerUi.dart';
// import 'package:fitcoach/utility/no_internet.dart';
// import 'package:fitcoach/utility/no_internet.dart';
// import 'package:fitcoach/utility/page_not_found.dart';
// import 'package:fitcoach/forget_screen/forget_screen.dart';
// import 'package:fitcoach/signup_screen/login_screen.dart';
// import 'package:fitcoach/signup_screen/signup_screen.dart';
// import 'package:fitcoach/spalsh_screen/spalsh.dart';
// import 'package:fitcoach/welcome_screen/wel_screen1.dart';
// import 'package:fitcoach/welcome_screen/wel_screen2.dart';
// import 'package:fitcoach/welcome_screen/wel_screen3.dart';
// import 'package:fitcoach/welcome_screen/wel_screen4.dart';
// import 'package:fitcoach/welcome_screen/wel_screen5.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_and_fitnessallUi/dashboard/dashboard.dart';

// import 'Comprehensive_screen/com_screen7.dart';
// import 'Comprehensive_screen/com_screen8.dart';
// import 'profile_screen/welcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Fitcoach',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: TextTheme(
          displayLarge:
              GoogleFonts.workSans(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium:
              GoogleFonts.workSans(fontSize: 28, fontWeight: FontWeight.bold),
          displaySmall:
              GoogleFonts.workSans(fontSize: 24, fontWeight: FontWeight.bold),
          headlineMedium:
              GoogleFonts.workSans(fontSize: 22, fontWeight: FontWeight.w600),
          headlineSmall:
              GoogleFonts.workSans(fontSize: 20, fontWeight: FontWeight.w600),
          titleLarge:
              GoogleFonts.workSans(fontSize: 18, fontWeight: FontWeight.w500),
          bodyLarge:
              GoogleFonts.workSans(fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium:
              GoogleFonts.workSans(fontSize: 14, fontWeight: FontWeight.normal),
          labelLarge:
              GoogleFonts.workSans(fontSize: 12, fontWeight: FontWeight.normal),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StepsTakenScreen(),
      // initialRoute: AppRoutes.splash,
      // getPages: AppRoutes.pages,
    );
  }
}

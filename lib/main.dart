import 'package:firebase_core/firebase_core.dart';
import 'package:fitcoach/Comprehensive_screen/heightUi.dart';
import 'package:fitcoach/calculatehealth/step_count2.dart';
import 'package:fitcoach/meal_create/mealUi/mealInfoUi.dart';
import 'package:fitcoach/meal_create/mealUi/mealList.dart';
import 'package:fitcoach/meal_create/mealUi/searchMealItem.dart';
import 'package:fitcoach/profile_setting/account_setting/linked_device.dart';
import 'package:fitcoach/profile_setting/notification/notificationUi.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/signup_screen/signup_screen.dart';
import 'package:fitcoach/spalsh_screen/spalsh.dart';
import 'package:fitcoach/test/test4.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/utility/hydrationUi.dart';
import 'package:fitcoach/utility/step_trackerUi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculatehealth/step_counter.dart';
import 'home_and_fitnessallUi/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: NutritionSummaryScreen(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}

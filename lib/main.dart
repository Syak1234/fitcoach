import 'package:firebase_core/firebase_core.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'CommunityAndResource/community_screen1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'Fitcoach',
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      // home: CommunityScreen1(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}

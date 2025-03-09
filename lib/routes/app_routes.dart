import 'package:fitcoach/CommunityAndResource/community_screen1.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen1.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen10.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen2.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen3.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen4.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen5.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen6.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen7.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen8.dart';
import 'package:fitcoach/Comprehensive_screen/com_screen9.dart';
import 'package:fitcoach/Comprehensive_screen/heightUi.dart';
import 'package:fitcoach/forget_screen/forget_screen.dart';
import 'package:fitcoach/home_and_fitnessallUi/dashboard/dashboard.dart';
import 'package:fitcoach/home_and_fitnessallUi/dashboard/dashboard_bottom.dart';
import 'package:fitcoach/meal_create/mealUi/customMealsScreen.dart';
import 'package:fitcoach/meal_create/mealUi/mealInfoUi.dart';
import 'package:fitcoach/meal_create/mealUi/mealList.dart';
import 'package:fitcoach/meal_create/mealUi/searchMealItem.dart';
import 'package:fitcoach/profile_setting/account_setting/about_us.dart';
import 'package:fitcoach/profile_setting/account_setting/account_dashboard.dart';
import 'package:fitcoach/profile_setting/account_setting/linked_device.dart';
import 'package:fitcoach/profile_setting/notification/notificationUi.dart';
import 'package:fitcoach/profile_setting/profile_screen/finger_print_setup.dart';
import 'package:fitcoach/profile_setting/profile_screen/profile_screen1.dart';
import 'package:fitcoach/profile_setting/profile_screen/profile_screen2.dart';
import 'package:fitcoach/profile_setting/profile_screen/welcomeScreen.dart';
import 'package:fitcoach/signup_screen/login_screen.dart';
import 'package:fitcoach/signup_screen/signup_screen.dart';
import 'package:fitcoach/spalsh_screen/spalsh.dart';
import 'package:fitcoach/utility/hydrationUi.dart';
import 'package:fitcoach/utility/no_internet.dart';
import 'package:fitcoach/utility/page_not_found.dart';
import 'package:fitcoach/utility/step_trackerUi.dart';
import 'package:fitcoach/welcome_screen/wel_screen1.dart';
import 'package:fitcoach/welcome_screen/wel_screen2.dart';
import 'package:fitcoach/welcome_screen/wel_screen3.dart';
import 'package:fitcoach/welcome_screen/wel_screen4.dart';
import 'package:fitcoach/welcome_screen/wel_screen5.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/';
  static const welcomeScreen1 = '/WelcomeScreen1';
  static const welcomeScreen2 = '/WelcomeScreen2';
  static const welcomeScreen3 = '/WelcomeScreen3';
  static const welcomeScreen4 = '/WelcomeScreen4';
  static const welcomeScreen5 = '/WelcomeScreen5';
  static const comScreen1 = '/ComScreen1';
  static const comScreen2 = '/ComScreen2';
  static const comScreen3 = '/ComScreen3';
  static const comScreen4 = '/ComScreen4';
  static const comScreen5 = '/ComScreen5';
  static const comScreen6 = '/ComScreen6';
  static const comScreen7 = '/ComScreen7';
  static const comScreen8 = '/ComScreen8';
  static const comScreen9 = '/ComScreen9';
  static const comScreen10 = '/ComScreen10';
  static const height = "/HeightSelectionScreen";

  static const login = '/SignInScreen';
  static const signup = '/SignUpScreen';
  static const forgetpasword = '/ResetPasswordScreen';
  static const internetcheck = '/NoInternetScreen';
  static const nodatafound = '/NotFoundScreen';
  static const dashboard = '/HomeScreen';
  static const profilescreen1 = '/ProfileScreen1';
  static const profileScreen2 = '/ProfileScreen2';
  static const fingerprintSetup = '/FingerprintSetup';
  static const welcomeScreen = '/WelcomeScreen';
  static const accountDashboard = '/AccountDashboard';
  static const bottomDashboard = '/DashboardBottom';

  static const aboutUs = "/AboutUsPage";

  static const linkDevice = "/LinkedDevicesScreen";

  static const notification = "/NotificationsScreen";
  static const stepUi = "/StepsTakenScreen";
  static const hydrationScreen = "/HydrationScreen";

  static const createMealScreen = "/CreateMealScreen";
  static const foodSearchScreen = "/FoodSearchScreen";
  static const nutritionSummaryScreen = "/NutritionSummaryScreen";
  static const customfoodscreen = "/CustomMealsScreen";

  static const commmunityScreen1 = '/CommunityScreen1';

  // Define routes here
  static final pages = [
    GetPage(
      name: splash,
      page: () => Spalsh(),
    ),

    /* Welcome Sceen  */
    GetPage(
      name: welcomeScreen1,
      page: () => WelcomeScreen1(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: welcomeScreen2,
      page: () => WelcomeScreen2(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: welcomeScreen3,
      page: () => WelcomeScreen3(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: welcomeScreen4,
      page: () => WelcomeScreen4(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: welcomeScreen5,
      page: () => WelcomeScreen5(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: welcomeScreen5,
      page: () => WelcomeScreen5(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: welcomeScreen5,
      page: () => WelcomeScreen5(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: welcomeScreen5,
      page: () => WelcomeScreen5(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /* ComScreen  */
    GetPage(
      name: comScreen1,
      page: () => ComScreen1(
          // userdetails: null,
          ),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen2,
      page: () => ComScreen2(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen3,
      page: () => ComScreen3(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen4,
      page: () => ComScreen4(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen5,
      page: () => ComScreen5(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen6,
      page: () => ComScreen6(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen7,
      page: () => ComScreen7(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen8,
      page: () => ComScreen8(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen9,
      page: () => ComScreen9(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: comScreen10,
      page: () => ComScreen10(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: height,
      page: () => HeightSelectionScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /* login & signup &forget password  */
    GetPage(
      name: login,
      page: () => SignInScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: signup,
      page: () => SignUpScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: forgetpasword,
      page: () => ResetPasswordScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /* internet,no data found screen  */

    GetPage(
      name: internetcheck,
      page: () => NoInternetScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: nodatafound,
      page: () => NotFoundScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /* dashboard screen  */

    GetPage(
      name: nodatafound,
      page: () => NotFoundScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /* profile & finger screen  */

    GetPage(
      name: profilescreen1,
      page: () => ProfileScreen1(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: profileScreen2,
      page: () => ProfileScreen2(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: welcomeScreen,
      page: () => WelcomeScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: fingerprintSetup,
      page: () => FingerprintSetup(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /* profile & finger screen  */
    GetPage(
      name: dashboard,
      page: () => HomeScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /* Account Dashboard & other screen  */
    GetPage(
      name: bottomDashboard,
      page: () => DashboardBottom(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: accountDashboard,
      page: () => AccountDashboard(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
/*About Us */
    GetPage(
      name: aboutUs,
      page: () => AboutUsPage(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
/*Linked Device */
    GetPage(
      name: linkDevice,
      page: () => LinkedDevicesScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /*Nofication Screen */
    GetPage(
      name: notification,
      page: () => NotificationsScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /*Step counter &  Screen */
    GetPage(
      name: stepUi,
      page: () => StepsTakenScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: hydrationScreen,
      page: () => HydrationScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),

    /*Meal screen*/
    GetPage(
      name: customfoodscreen,
      page: () => CustomMealsScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: createMealScreen,
      page: () => CreateMealScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: foodSearchScreen,
      page: () => FoodSearchScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: nutritionSummaryScreen,
      page: () => NutritionSummaryScreen(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
    GetPage(
      name: commmunityScreen1,
      page: () => CommunityScreen1(),
      transition: Transition.rightToLeft, // Optional: Add transition animations
    ),
  ];
}

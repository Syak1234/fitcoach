import 'dart:convert';
import 'dart:developer';

import 'package:fitcoach/Comprehensive_screen/com_screen1.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api_url.dart';
import 'package:fitcoach/modelClass/mealItemList.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/signup_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class SharedPrefHelper {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

Future signUp(BuildContext context, String userName, String pass,
    String confirmPass) async {
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {
      "userName": userName,
      "password": pass,
      "confirmPassword": confirmPass,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
    };

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    var res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.register),
      headers: headers,
      body: jsonEncode(obj),
    );

    Get.back(); // Close the loading dialog

    var jsondata = jsonDecode(res.body);
    log(jsondata.toString());
    log(res.statusCode.toString());

    if (res.statusCode == 200) {
      toastification.show(
        context: context,
        title: const Text('Signup Successful!'),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } else {
      toastification.show(
        context: context,
        title: Text('Signup Failed: ${jsondata['message'] ?? 'Unknown error'}'),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  } catch (e) {
    Get.back();
    log(e.toString());

    toastification.show(
      context: context,
      title: const Text('Something went wrong!'),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}

Future loginApi(BuildContext context, String userName, String pass) async {
  try {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {
      "userName": userName,
      "password": pass,
    };

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
    };

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.login),
      headers: headers,
      body: jsonEncode(obj),
    );

    Get.back();

    if (res.statusCode == 200) {
      Map data = jsonDecode(res.body.toString());
      final jsondata = data["result"];

      log(jsondata['id'] + "hjhjhjhj");

      await SharedPrefHelper.setString("userid", jsondata['id']);
      await SharedPrefHelper.setString("username", jsondata['userName']);
      await SharedPrefHelper.setString("token", jsondata['token']);

      toastification.show(
        context: context,
        title: const Text('Login Successful'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );

      Get.toNamed(AppRoutes.fingerprintSetup);
    } else {
      toastification.show(
        context: context,
        title: const Text('Login Failed'),
        description:
            Text(jsonDecode(res.body)['message'] ?? 'Something went wrong'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  } catch (e) {
    Get.back();
    log(e.toString());
    toastification.show(
      context: context,
      title: const Text('Error'),
      description: Text(e.toString()),
      autoCloseDuration: const Duration(seconds: 3),
      type: ToastificationType.error,
    );
  }
}

Future createMealApi(
  BuildContext context, {
  required String mealname,
  required dynamic
      mealController, // Replace 'dynamic' with your actual controller type
}) async {
  try {
    String? token = await SharedPrefHelper.getString('token');
    List<Map<String, dynamic>> mealItemsJson =
        mealController.mealItems.map((item) => item.toJson()).toList();

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    String userid = await SharedPrefHelper.getString('userid') ?? '';
    Map obj = {
      "mealName": mealname,
      "userId": userid,
      "mealItems": mealItemsJson,
    };

    log("Request: $obj");

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.createMeal),
      headers: headers,
      body: jsonEncode(obj),
    );

    Get.back(); // close loading dialog

    var jsondata = jsonDecode(res.body);
    log("Response: $jsondata");

    if (res.statusCode == 200) {
      toastification.show(
        context: context,
        title: const Text('Meal Created'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
    } else {
      toastification.show(
        context: context,
        title: const Text('Failed to Create Meal'),
        description: Text(jsondata['message'] ?? 'Unexpected error occurred'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  } catch (e) {
    Get.back(); // close loading dialog
    log("Error: $e");
    toastification.show(
      context: context,
      title: const Text('Error'),
      description: Text(e.toString()),
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}

Future<List<Meal>> allListMealApi(BuildContext context) async {
  try {
    String? token = await SharedPrefHelper.getString('token');
    String userid = await SharedPrefHelper.getString('userid') ?? '';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    var res = await client.get(
      Uri.https(ApiUrl.baseUrl, ApiUrl.getMealList + userid),
      headers: headers,
    );

    if (res.statusCode == 200) {
      var jsondata = jsonDecode(res.body);
      List<Meal> meals =
          (jsondata['result'] as List).map((e) => Meal.fromJson(e)).toList();
      return meals;
    } else {
      throw Exception("Failed to load meals");
    }
  } catch (e) {
    log(e.toString());
    throw Exception("Error fetching meals");
  }
}
Future updateMealApi(
  BuildContext context, {
  required int id,
  required String mealname,
  required dynamic mealController, // Replace 'dynamic' with the actual type if known
}) async {
  try {
    String? token = await SharedPrefHelper.getString('token');
    List<Map<String, dynamic>> mealItemsJson =
        mealController.mealItems.map((item) => item.toJson()).toList();

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {
      "id": id,
      "mealName": mealname,
      "mealItems": mealItemsJson
    };

    log("Update Request: $obj");

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.updatemela),
      headers: headers,
      body: jsonEncode(obj),
    );

    Get.back(); // Close loading dialog

    var jsondata = jsonDecode(res.body);
    log("Update Response: $jsondata");

    if (res.statusCode == 200) {
      toastification.show(
        context: context,
        title: const Text('Meal Updated'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
    } else {
      toastification.show(
        context: context,
        title: const Text('Update Failed'),
        description: Text(jsondata['message'] ?? 'Unexpected error occurred'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  } catch (e) {
    Get.back(); // Close loading dialog
    log("Update Error: $e");
    toastification.show(
      context: context,
      title: const Text('Error'),
      description: Text(e.toString()),
      autoCloseDuration: const Duration(seconds: 3),
      type: ToastificationType.error,
    );
  }
}
Future createUserDetails({
  required String userId,
  required String fitnessGoal,
  required String gender,
  required int weight,
  required int height,
  required bool previousFitnessExperience,
  required String specificDiet,
  required int daysCommit,
  required String specificExperiencePreferance,
  required String calorieyGoal,
  required String sleepQuality,
  required BuildContext context, // Added BuildContext parameter for toast
}) async {
  try {
    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.createuserdetails);
    String? token = await SharedPrefHelper.getString('token');
    final body = jsonEncode({
      "userId": userId,
      "fitnessGoal": fitnessGoal,
      "gender": gender,
      "weight": weight,
      "height": height,
      "previousFitnessExperience": previousFitnessExperience,
      "specificDiet": specificDiet,
      "daysCommit": daysCommit,
      "specificExperiencePreferance": specificExperiencePreferance,
      "calorieyGoal": calorieyGoal,
      "sleepQuality": sleepQuality,
    });

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(url, headers: headers, body: body);

    Get.back(); // Close loading dialog

    log(response.body.toString());

    if (response.statusCode == 200) {
      // Success toast
      toastification.show(
        context: context,
        title: const Text('User Details Created'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
      // Optional: Navigate to next screen (e.g., fingerprint setup)
      // Get.toNamed(AppRoutes.fingerprintSetup);
    } else {
      // Failure toast with error message from response
      var jsondata = jsonDecode(response.body);
      toastification.show(
        context: context,
        title: const Text('Error'),
        description: Text(jsondata['message'] ?? 'Failed to create user details'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  } catch (e) {
    Get.back(); // Close loading dialog
    log("Error: $e");
    toastification.show(
      context: context,
      title: const Text('Error'),
      description: Text(e.toString()),
      autoCloseDuration: const Duration(seconds: 3),
      type: ToastificationType.error,
    );
  }
}

Future updateUserDetails({
  required String fitnessGoal,
  required String gender,
  required int weight,
  required int height,
  required bool previousFitnessExperience,
  required String specificDiet,
  required int daysCommit,
  required String specificExperiencePreferance,
  required String calorieyGoal,
  required String sleepQuality,
}) async {
  try {
    String? token = await SharedPrefHelper.getString('token');

    String userid = await SharedPrefHelper.getString('userid') ?? '';
    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.updateUserdeatils + userid);
    final body = jsonEncode({
      "fitnessGoal": fitnessGoal,
      "gender": gender,
      "weight": weight,
      "height": height,
      "previousFitnessExperience": previousFitnessExperience,
      "specificDiet": specificDiet,
      "daysCommit": daysCommit,
      "specificExperiencePreferance": specificExperiencePreferance,
      "calorieyGoal": calorieyGoal,
      "sleepQuality": sleepQuality,
    });

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(url, headers: headers, body: body);
    Get.back();
    log(response.body.toString());
    if (response.statusCode == 200) {
      // Get.toNamed(
      //   AppRoutes.fingerprintSetup,
      // );
    }
  } catch (e) {
    Get.back();
    log(e.toString());
  }
}

Future getUserDetails() async {
  try {
    String? token = await SharedPrefHelper.getString('token');
    String userid = await SharedPrefHelper.getString('userid') ?? '';
    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.createuserdetails + userid);
    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    Get.back();
    log(response.body.toString());
    if (response.statusCode == 200) {}
  } catch (e) {
    Get.back();
    log(e.toString());
  }
}

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

Future signUp(context, userName, pass, confirmPass) async {
  try {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Map obj = {
      "userName": userName,
      "password": pass,
      "confirmPassword": confirmPass
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
    };

    // Ignore SSL certificate verification (for local testing)
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    var res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.register),
      headers: headers,
      body: jsonEncode(obj),
    );

    var jsondata = jsonDecode(res.body);
    log(jsondata.toString());
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      Get.back();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ));
    }
  } catch (e) {
    Get.back();
    log(e.toString());
  }
}

Future loginApi(context, userName, pass) async {
  try {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Map obj = {
      "userName": userName,
      "password": pass,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
    };

    // Ignore SSL certificate verification (for local testing)
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    var res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.login),
      headers: headers,
      body: jsonEncode(obj),
    );

    Map data = await jsonDecode(res.body.toString());
    log(data.toString());
    final jsondata = data["result"];

    if (res.statusCode == 200) {
      log(jsondata['id'] + "hjhjhjhj");
      SharedPrefHelper.setString("userid", jsondata['id']);
      SharedPrefHelper.setString("username", jsondata['userName']);
      SharedPrefHelper.setString("token", jsondata['token']);
      Get.back();
      Get.toNamed(
        AppRoutes.fingerprintSetup,
      );
    }
  } catch (e) {
    Get.back();
    log(e.toString());
  }
}

Future createMealApi(
  context, {
  required String mealname,
  required Getx mealController,
  // required String protein,
  // required String fat,
  // required String carbohydrates,
  // required String kcal,
  // required String carbohydratePercentage,
  // required String fatPercentage,
  // required String proteinPercentage,
  // required String name,
  // required String dataSource,
  // required String servingSize
}) async {
  try {
    String? token = await SharedPrefHelper.getString('token');
    List<Map<String, dynamic>> mealItemsJson =
        mealController.mealItems.map((item) => item.toJson()).toList();
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    String userid = await SharedPrefHelper.getString('userid') ?? '';
    Map obj = {
      "mealName": mealname,
      "userId": userid,
      "mealItems": mealItemsJson
    };

    log(obj.toString());

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    // Ignore SSL certificate verification (for local testing)
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    var res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.createMeal),
      headers: headers,
      body: jsonEncode(obj),
    );

    var jsondata = await jsonDecode(res.body);
    log(jsondata.toString());

    Get.back();
    if (res.statusCode == 200) {
      // Get.toNamed(
      //   AppRoutes.fingerprintSetup,
      // );
    }
  } catch (e) {
    Get.back();
    log(e.toString());
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

Future upadteMealApi(
  context, {
  required int id,
  required String mealname,
  required Getx mealController,
  // required String protein,
  // required String fat,
  // required String carbohydrates,
  // required String kcal,
  // required String carbohydratePercentage,
  // required String fatPercentage,
  // required String proteinPercentage,
  // required String name,
  // required String dataSource,
  // required String servingSize
}) async {
  try {
    String? token = await SharedPrefHelper.getString('token');
    List<Map<String, dynamic>> mealItemsJson =
        mealController.mealItems.map((item) => item.toJson()).toList();
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    String userid = await SharedPrefHelper.getString('userid') ?? '';
    Map obj = {
      "id": id,
      "mealName": mealname,
      // "userId": userid,
      "mealItems": mealItemsJson
    };

    log(obj.toString());

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    // Ignore SSL certificate verification (for local testing)
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    var res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.updatemela),
      headers: headers,
      body: jsonEncode(obj),
    );

    var jsondata = await jsonDecode(res.body);
    log(jsondata.toString());

    Get.back();
    if (res.statusCode == 200) {
      // Get.toNamed(
      //   AppRoutes.fingerprintSetup,
      // );
    }
  } catch (e) {
    Get.back();
    log(e.toString());
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
    if (response.statusCode == 200) {
     
    }
  } catch (e) {
    Get.back();
    log(e.toString());
  }
}

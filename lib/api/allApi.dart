import 'dart:convert';
import 'dart:developer';

import 'package:fitcoach/api_url.dart';
import 'package:fitcoach/routes/app_routes.dart';
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
    Get.back();
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

Future createMealApi(context,
    {required String mealname,
    String userid = "5ae35e85-5ab7-4ed1-a994-55054a8bbba9",
    required String protein,
    required String fat,
    required String carbohydrates,
    required String kcal,
    required String carbohydratePercentage,
    required String fatPercentage,
    required String proteinPercentage,
    required String name,
    required String dataSource,
    required String servingSize}) async {
  try {
    String? token = await SharedPrefHelper.getString('token');
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Map obj = {
      "mealName": mealname,
      "userId": userid,
      "mealItems": [
        {
          "protein": protein,
          "fat": fat,
          "carbohydrates": carbohydrates,
          "kcal": kcal,
          "servingSize": servingSize,
          "dataSource": dataSource,
          "name": name,
          "proteinPercentage": proteinPercentage,
          "fatPercentage": fatPercentage,
          "carbohydratePercentage": carbohydratePercentage
        }
      ]
    };

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

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

    var jsondata = jsonDecode(res.body);
    log(jsondata.toString());

    Get.back();
    if (res.statusCode == 200) {
      Get.toNamed(
        AppRoutes.fingerprintSetup,
      );
    }
  } catch (e) {
    Get.back();
    log(e.toString());
  }
}

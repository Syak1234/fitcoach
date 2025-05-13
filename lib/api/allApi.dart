import 'dart:convert';
import 'dart:developer';

import 'package:fitcoach/Comprehensive_screen/com_screen1.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api_url.dart';
import 'package:fitcoach/home_and_fitnessallUi/dashboard/dashboard.dart';
import 'package:fitcoach/modelClass/mealItemList.dart';
import 'package:fitcoach/modelClass/stepandwatermodelclass.dart';
import 'package:fitcoach/modelClass/userDetails.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/signup_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
// import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

Getx getx = Get.put(Getx());

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

Future signUp(
    BuildContext context, String userName, String pass, String type) async {
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {
      "userName": userName,
      "password": pass,
      "type": type,
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
      var result = jsondata['result'];
      getx.token.value = result['token'].toString();
      getx.username.value = result['userName'].toString();
      getx.userid.value = result['id'].toString();
      await SharedPrefHelper.setString("userid", result['id'].toString());
      await SharedPrefHelper.setString(
          "username", result['userName'].toString());
      await SharedPrefHelper.setString("token", result['token'].toString());
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

Future loginApi(
    BuildContext context, String userName, String pass, String type) async {
  try {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {
      "userName": userName,
      "password": pass,
      "type": type,
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

    log(res.body);
    Map data = jsonDecode(res.body.toString());

    if (res.statusCode == 200) {
      final jsondata = data["result"];

      log(jsondata['id'] + "hjhjhjhj");
      getx.token.value = jsondata['token'].toString();
      getx.username.value = jsondata['userName'].toString();
      getx.userid.value = jsondata['id'].toString();

      await SharedPrefHelper.setString("userid", jsondata['id']);
      await SharedPrefHelper.setString("username", jsondata['userName']);
      await SharedPrefHelper.setString("token", jsondata['token']);
      await SharedPrefHelper.setBool("IsLogin", true);

      toastification.show(
        context: context,
        title: const Text('Login Successful'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );

      getx.pagesIndex.value = 0;
      // Get.back();

      Get.toNamed(AppRoutes.fingerprintSetup);
    } else {
      toastification.show(
        context: context,
        title: const Text('Login Failed'),
        description:
            Text(data['errorMessages'].toString() ?? 'Something went wrong'),
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

// import 'dart:convert';

Map<String, dynamic>? extractJwtPayload(String? token) {
  if (token == null || token.isEmpty) {
    return null;
  }

  List<String> parts = token.split('.');

  if (parts.length != 3) {
    return null; // invalid JWT format
  }

  String payload = parts[1];

  // Normalize and decode Base64Url
  String normalized = base64Url.normalize(payload);
  String decoded = utf8.decode(base64Url.decode(normalized));

  Map<String, dynamic> jsonPayload = json.decode(decoded);

  print(jsonPayload.toString());
  return jsonPayload;
}

Future createMealApi(
  BuildContext context, {
  required String mealname,
  required Getx
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
      // toastification.show(
      //   context: context,
      //   title: const Text('Failed to Create Meal'),
      //   description: Text(jsondata['message'] ?? 'Unexpected error occurred'),
      //   type: ToastificationType.error,
      //   autoCloseDuration: const Duration(seconds: 3),
      // );
    }
  } catch (e) {
    Get.back(); // close loading dialog
    log("Error: x $e");
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
    log("meal list " + res.body.toString());
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
  required String id,
  required String mealname,
  required Getx
      mealController, // Replace 'dynamic' with the actual type if known
}) async {
  // try {
  String? token = await SharedPrefHelper.getString('token');
  List<Map<String, dynamic>> mealItemsJson =
      mealController.mealItems.map((item) => item.toJson()).toList();

  showDialog(
    context: context,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  Map obj = {"id": id, "mealName": mealname, "mealItems": mealItemsJson};

  log("Update Request: $obj");

  final headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
    // 'Authorization': 'Bearer $token'
  };

  final ioClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  final client = IOClient(ioClient);

  log(obj.toString());

  final res = await client.post(
    Uri.https(ApiUrl.baseUrl, ApiUrl.updatemela),
    headers: headers,
    body: jsonEncode(obj),
  );

  Get.back(); // Close loading dialog

  var jsondata = jsonDecode(res.body.toString());
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
  // } catch (e) {
  //   Get.back(); // Close loading dialog
  //   log("Update Error: $e");
  //   toastification.show(
  //     context: context,
  //     title: const Text('Error'),
  //     description: Text(e.toString()),
  //     autoCloseDuration: const Duration(seconds: 3),
  //     type: ToastificationType.error,
  //   );
  // }
}

Future createUserDetails({
  required String userId,
  required String fitnessGoal,
  required String gender,
  required String weight,
  required int height,
  required bool previousFitnessExperience,
  required String specificDiet,
  required int daysCommit,
  required String specificExperiencePreferance,
  required String calorieyGoal,
  required String sleepQuality,
  required String age,
  required BuildContext context,
  File? profileImage, // <-- Add this if you want to upload an image
}) async {
  try {
    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.createuserdetails);
    String? token = getx.token.value;

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      "UserId": userId,
      "FitnessGoal": fitnessGoal,
      "Gender": gender,
      "Weight": weight,
      "Height": height.toString(),
      "PreviousFitnessExperience": previousFitnessExperience.toString(),
      "SpecificDiet": specificDiet,
      "DaysCommit": daysCommit.toString(),
      "SpecificExperiencePreferance": specificExperiencePreferance,
      "CalorieyGoal": calorieyGoal,
      "SleepQuality": sleepQuality,
      "Age": age,
    });

    // Attach image if provided
    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('ProfileImage', profileImage.path),
      );
    }

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    log(response.body);

    if (response.statusCode == 200) {
      toastification.show(
        context: context,
        title: const Text('User Details Created'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
    } else {
      var jsondata = jsonDecode(response.body);
      toastification.show(
        context: context,
        title: const Text('Error'),
        description:
            Text(jsondata['errorMessages'] ?? 'Failed to create user details'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  } catch (e) {
    log("Error: $e");
    // toastification.show(
    //   context: context,
    //   title: const Text('Error'),
    //   description: Text("SomeThing went Wrong!!"),
    //   autoCloseDuration: const Duration(seconds: 3),
    //   type: ToastificationType.error,
    // );
  }
}

Future updateUserDetails({
  required String userId,
  required String fitnessGoal,
  required String gender,
  required String weight,
  required String height,
  required bool previousFitnessExperience,
  required String specificDiet,
  required int daysCommit,
  required String specificExperiencePreferance,
  required String calorieyGoal,
  required String sleepQuality,
  required String age,
  required BuildContext context,
  File? profileImage, // <-- added optional File parameter
}) async {
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.updateUserdeatils + userId);
    String? token = await SharedPrefHelper.getString('token');

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll({
      "UserId": userId,
      "FitnessGoal": fitnessGoal,
      "Gender": gender,
      "Weight": weight,
      "Height": height.toString(),
      "PreviousFitnessExperience": previousFitnessExperience.toString(),
      "SpecificDiet": specificDiet,
      "DaysCommit": daysCommit.toString(),
      "SpecificExperiencePreferance": specificExperiencePreferance,
      "CalorieyGoal": calorieyGoal,
      "SleepQuality": sleepQuality,
      "Age": age,
    });

    // Check if profileImage is provided
    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'ProfileImage',
          profileImage.path,
        ),
      );
    } else {
      // If no image, send an empty string as before
      request.fields['ProfileImage'] = '';
    }

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    log(response.body);

    if (response.statusCode == 202) {
      Get.back();
      toastification.show(
        context: context,
        title: const Text('User Details Updated'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
    } else {
      Get.back();
      var jsondata = jsonDecode(response.body);
      toastification.show(
        context: context,
        title: const Text('Error'),
        description:
            Text(jsondata['message'] ?? 'Failed to Update user details'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  } catch (e) {
    Get.back();
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

Future<bool> getUserDetails() async {
  try {
    String? token = await SharedPrefHelper.getString('token');
    String userid = await SharedPrefHelper.getString('userid') ?? '';
    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.getUserdeatils + userid);
    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);
    final response = await client.get(
      url,
      headers: headers,
    );
    // Get.back();
    log(response.body.toString());
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final result = decoded['result'];
      List<String> specificExperienceList =
          result['specificExperiencePreferance']
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .split(',')
              .map((e) => e.trim())
              .where((String e) => e.isNotEmpty)
              .toList();

      UserAssessmentDetaiils details = UserAssessmentDetaiils(
          fitnessGoal: result['fitnessGoal'].toString(),
          gender: result['gender'].toString(),
          weight: result['weight'].toString(),
          height: result['height'].toString(),
          previousFitnessExperience:
              result['previousFitnessExperience'].toString(),
          specificDiet: result['specificDiet'].toString(),
          daysCommit: result['daysCommit'].toString(),
          specificExperiencePreferance: specificExperienceList ?? [],
          calorieyGoal: result['calorieyGoal'].toString(),
          sleepQuality: result['sleepQuality'].toString(),
          age: result["age"].toString(),
          profileimage: result["profileImageUrl"].toString(),
          bmi: result["bmi"].toString());

      // }
      getx.bmi.value = result["bmi"].toString();
      getx.profileImageUrl.value = result["profileImageUrl"].toString();
      getx.profileImageFullUrl.value =
          "https://" + ApiUrl.baseUrl + result["profileImageUrl"].toString();

      getx.userAssessmentDetaiils.value = [details];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fitness_goal', result['fitnessGoal'].toString());

      // await prefs.setString('fitness_goal', result['fitnessGoal'].toString());
      await prefs.setString('selected_gender', result['gender'].toString());
      await prefs.setString('weight', result['weight'].toString());

      await prefs.setInt('user_height_cm', int.parse(result['height']) ?? 0);
      await prefs.setBool(
          'isFitnessExp', result['previousFitnessExperience'] ?? false);
      await prefs.setString('diet', result['specificDiet'].toString());
      await prefs.setInt('work_day_commit', result['daysCommit'] ?? 0);
      await prefs.setStringList('excercise_pref', specificExperienceList);
      await prefs.setString(
          'kcal_goal_perday', result['calorieyGoal'].toString());
      await prefs.setString('sleep', result['sleepQuality'].toString());
      await prefs.setString('age', result['age'].toString());

      log(response.body.toString());
      return true;
    } else {
      log(response.body.toString());
      log(response.statusCode.toString());
      return false;
    }
  } catch (e) {
    // Get.back();
    log(e.toString());
    return false;
  }
}

Future<bool> logoutFunction() async {
  try {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("userid");
    sp.remove("username");
    sp.remove("token");
    sp.setBool("IsLogin", false);

    return true;
  } catch (e) {
    return false;
  }
}

Future<List<Map<String, dynamic>>> getAllWorkout() async {
  try {
    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.allworkOutList);
    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
    };

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final client = IOClient(ioClient);
    final response = await client.get(url, headers: headers);
    log('Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['result']);
    } else {
      throw Exception('Failed to load workouts');
    }
  } catch (e) {
    log('Error: $e');
    return [];
  }
}

Future<bool> deleteMeal(BuildContext context, {required String id}) async {
  try {
    // Uncomment if your API requires authentication
    // String? token = await SharedPrefHelper.getString('token');
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    final url = Uri.https(ApiUrl.baseUrl, '${ApiUrl.deletemeal}$id');

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      // 'Authorization': 'Bearer $token',
    };

    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final response = await client.post(
      // Change to .delete() if API supports DELETE
      url,
      headers: headers,
    );
    Get.back();
    Get.back();
    log(response.body);

    if (response.statusCode == 200) {
      Get.back();
      toastification.show(
        context: context,
        title: const Text('Meal deleted successfully!'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
      return true;
    } else {
      final jsonData = jsonDecode(response.body);
      toastification.show(
        context: context,
        title: const Text('Delete Failed'),
        description: Text(
          jsonData['errorMessages']
                  ?.toString()
                  .replaceAll('[', '')
                  .replaceAll(']', '') ??
              'An unknown error occurred',
        ),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
      return false;
    }
  } catch (e) {
    log('Delete error: $e');
    toastification.show(
      context: context,
      title: const Text('Error'),
      description: Text(e.toString()),
      type: ToastificationType.error,
    );
    return false;
  }
}

Future deleteworkout({required int id}) async {
  try {
    // String? token = await SharedPrefHelper.getString('token');

    // String userid = await SharedPrefHelper.getString('userid') ?? '';
    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.deleteworkOut + id.toString());

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      // 'Authorization': 'Bearer $token'
    };
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);
    final response = await client.get(
      url,
      headers: headers,
    );
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

Future<bool> genarateFPcode(
  BuildContext context, {
  required String email,
  // Replace 'dynamic' with the actual type if known
}) async {
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {"email": email};

    log("Update Request: $obj");

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      // 'Authorization': 'Bearer $token'
    };
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.genarateFPotp),
      headers: headers,
      body: jsonEncode(obj),
    );

    Get.back(); // Close loading dialog

    var jsondata = jsonDecode(res.body);
    log("Update Response: $jsondata");

    if (res.statusCode == 200) {
      toastification.show(
        context: context,
        title: const Text('OTP send successfully!'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
      return true;
    } else {
      toastification.show(
        context: context,
        title: const Text('send Failed'),
        description: Text(jsondata['errorMessages']
            .toString()
            .replaceAll('[', "")
            .replaceAll("]", "")),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  } catch (e) {
    Get.back(); // Close loading dialog
    log("OTP send Error: $e");
    toastification.show(
      context: context,
      title: const Text('Error'),
      description: Text(e.toString()),
      autoCloseDuration: const Duration(seconds: 3),
      type: ToastificationType.error,
    );
  }
  return false;
}

Future<bool> resetPassword(BuildContext context,
    {required String email, required String otp, required String newPassword
    // Replace 'dynamic' with the actual type if known
    }) async {
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {"email": email, "otp": otp, "newPassword": newPassword};

    log("Update Request: $obj");

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      // 'Authorization': 'Bearer $token'
    };
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final res = await client.post(
      Uri.https(ApiUrl.baseUrl, ApiUrl.resetPassword),
      headers: headers,
      body: jsonEncode(obj),
    );

    Get.back(); // Close loading dialog

    var jsondata = jsonDecode(res.body);
    log("Update Response: $jsondata");

    if (res.statusCode == 200) {
      toastification.show(
        context: context,
        title: const Text('Password Reset successfully!'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
      return true;
    } else {
      toastification.show(
        context: context,
        title: const Text(' Failed'),
        description: Text(jsondata['errorMessages']
            .toString()
            .replaceAll('[', "")
            .replaceAll("]", "")),
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
  return false;
}

Future<bool> checkEmailExistOrNot(String email, BuildContext context) async {
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Map obj = {"email": email, "otp": otp, "newPassword": newPassword};

    // log("Update Request: $obj");

    final url =
        Uri.https(ApiUrl.baseUrl, ApiUrl.checkuserEmail, {"email": email});

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      // 'Authorization': 'Bearer $token'
    };
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final res = await client.get(
      url,
      headers: headers,
    );

    Get.back(); // Close loading dialog

    var jsondata = jsonDecode(res.body);
    log("Update Response: $jsondata");

    if (res.statusCode == 200 && jsondata["result"] ?? false) {
      // toastification.show(
      //   context: context,
      //   title: const Text('Password Reset successfully!'),
      //   autoCloseDuration: const Duration(seconds: 3),
      //   type: ToastificationType.success,
      //   style: ToastificationStyle.fillColored,
      // );
      return true;
    } else {
      toastification.show(
        context: context,
        title: const Text(' Failed'),
        description: Text(jsondata['errorMessages']
            .toString()
            .replaceAll('[', "")
            .replaceAll("]", "")),
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
  return false;
}

Future<bool> updateData({
  required String date,
  required int step,
  required dynamic minutes,
  required dynamic km,
  required dynamic kcal,
  required dynamic id,
}) async {
  final url = Uri.https(ApiUrl.baseUrl, '/api/DailyStepActivity/update/$id');

  final Map<String, dynamic> requestBody = {
    "date": date,
    "step": step.toString(),
    "minutes": minutes.toString(),
    "km": km.toString(),
    "kcal": kcal.toString(),
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    log(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      log('Failed: ${response.statusCode}, ${response.body}');
      return false;
    }
  } catch (e) {
    log('Exception: $e');
    return false;
  }
}

Future<void> fetchServiceData() async {
  // final String userId = 'hjhjjh';
  final Uri url = Uri.parse(
      '${ApiUrl.baseUrl}/api/InternalService/get-all'); // Replace with actual URL

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Success: $data');
    } else {
      print('Failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> fetchstepandwaterlistAfterUpdate({required String userId}) async {
  // final String userId = 'hjhjjh';
  final Uri url = Uri.parse(
      '${ApiUrl.baseUrl}/api/DailyActivity/$userId'); // Replace with actual URL

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Success: $data');
    } else {
      print('Failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<String> getInternalService({required String serviceName}) async {
  String serviceValue = "";
  getx.loadingWidget.value = true;

  try {
    String? token = await SharedPrefHelper.getString('token');
    final url =
        Uri.https(ApiUrl.baseUrl, ApiUrl.getInternalService + serviceName);
    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token'
    };
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);
    final response = await client.get(
      url,
      headers: headers,
    );
    // Get.back();
    log(response.body.toString());
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      // final result = decoded['result'];/

      // Check if `result` is a list
      final resultList = decoded['result'] as List<dynamic>;

      if (resultList.length == 1) {
        // Only one item → take its serviceValue
        serviceValue = resultList[0]['serviceValue'];
        log('Only one item. Service Value: $serviceValue');
      } else {
        // Multiple items → find the one with id == 4
        final targetItem = resultList.firstWhere(
          (item) => item['id'] == 4,
          orElse: () => null,
        );

        if (targetItem != null) {
          serviceValue = targetItem['serviceValue'];
          log('Found item with id == 4. Service Value: $serviceValue');
        } else {
          log('No item found with id == 4');
        }
      }
      log(response.body.toString());
    } else {
      log(response.body.toString());
      log(response.statusCode.toString());
    }
  } catch (e) {
    // Get.back();
    log(e.toString());
  }
  getx.loadingWidget.value = false;
  return serviceValue;
}

Future<int> createWaterDetails(String userId, BuildContext context,
    String waterQuantity, String date) async {
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {
      "userId": userId,
      // "date": "2025-05-11T07:21:43.571Z",
      "date": date,

      "water": waterQuantity
    };

    // log("Update Request: $obj");

    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.createWater);

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      // 'Authorization': 'Bearer $token'
    };
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final res = await client.post(url, headers: headers, body: jsonEncode(obj));

    var jsondata = jsonDecode(res.body);
    log("Update Response: $jsondata");

    if (res.statusCode == 200) {
      toastification.show(
        context: context,
        title: const Text('Insert Water Details Successfully!'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
      Get.back(); // Close loading dialog

      return res.statusCode;
    } else if (res.statusCode == 409) {
      Get.back(); // Close loading dialog

      return res.statusCode;
    } else {
      toastification.show(
        context: context,
        title: const Text(' Failed'),
        description: Text(jsondata['errorMessages']
            .toString()
            .replaceAll('[', "")
            .replaceAll("]", "")),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
      Get.back(); // Close loading dialog

      return res.statusCode;
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
    return 500;
  }
}

Future<bool> createStepData({
  required BuildContext context,
  required String userId,
  required String date,
  required int step,
  required dynamic minutes,
  required dynamic km,
  required dynamic kcal,
}) async {
  final url = Uri.https(ApiUrl.baseUrl, ApiUrl.createStep);

  final Map<String, dynamic> payload = {
    "userId": userId,
    "date": date,
    "step": step.toString(),
    "minutes": minutes.toString(),
    "km": km.toString(),
    "kcal": kcal.toString()
  };

  log("Request Payload: $payload");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    log("Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      toastification.show(
        context: context,
        title: const Text('Insert Step Details Successfully!'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );
      return true;
    } else {
      // toastification.show(
      //   context: context,
      //   title: Text('Failed to Insert Step Data (${response.statusCode})'),
      //   type: ToastificationType.error,
      //   autoCloseDuration: Duration(seconds: 3),
      //   style: ToastificationStyle.fillColored,
      // );
      return false;
    }
  } catch (e) {
    log('Exception during API call: $e');

    toastification.show(
      context: context,
      title: Text('Error: $e'),
      type: ToastificationType.error,
      autoCloseDuration: Duration(seconds: 3),
      style: ToastificationStyle.fillColored,
    );

    return false;
  }
}

Future<int> updateWaterDetails(String userId, BuildContext context, int waterid,
    String waterQuantity, String date) async {
  HistoryCalendarState new_obj = HistoryCalendarState();
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Map obj = {
      "userId": userId,
      "date": date,
      "water": waterQuantity,
      "id": waterid
    };

    // log("Update Request: $obj");

    final url = Uri.https(ApiUrl.baseUrl, ApiUrl.addWater);

    final headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      // 'Authorization': 'Bearer $token'
    };
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioClient);

    final res = await client.post(url, headers: headers, body: jsonEncode(obj));

    var jsondata = jsonDecode(res.body);
    log("Update Response: $jsondata");

    if (res.statusCode == 200) {
      toastification.show(
        context: context,
        title: const Text('Add Water intake Successfully!'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
      );

      Get.back(); // Close loading dialog

      return res.statusCode;
    } else if (res.statusCode == 409) {
      Get.back(); // Close loading dialog

      return res.statusCode;
    } else {
      toastification.show(
        context: context,
        title: const Text(' Failed'),
        description: Text(jsondata['errorMessages']
            .toString()
            .replaceAll('[', "")
            .replaceAll("]", "")),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
      Get.back(); // Close loading dialog

      return res.statusCode;
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
    return 500;
  }
}

Future<void> fetchStepAndWaterList(
    {required String userId, required BuildContext context}) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final Uri url = Uri.https(ApiUrl.baseUrl,
        '/api/DailyStepActivity/GetStepAndActivityByUser/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['result'] is Map<String, dynamic>) {
        final result = data['result'] as Map<String, dynamic>;

        final stepList = (result['dailyStepActivityList'] as List<dynamic>?)
                ?.map((e) => StepActivity.fromJson(e))
                .toList() ??
            [];

        final waterList = (result['dailyActivityList'] as List<dynamic>?)
                ?.map((e) => WaterActivity.fromJson(e))
                .toList() ??
            [];

        getx.setStepList(stepList);
        final today = DateTime.now();
        final filteredWaterList = waterList.where((activity) {
          final activityDate = DateTime.parse(
              activity.date.toString()); // ensure this parses correctly
          return activityDate.year == today.year &&
              activityDate.month == today.month &&
              activityDate.day == today.day;
        }).toList();

        getx.setWaterList(filteredWaterList);

        print(getx.waterList[0].water);

        Get.back();

        // if (_selectedDay != null) {
        //   _filterDataForSelectedDate();
        // }
      } else {
        Get.back();

        print('Unexpected result format');
      }
    } else {
      Get.back();

      print('Failed with status code: ${response.statusCode}');
    }
  } catch (e, stack) {
    Get.back();

    print('Fetch error: $e');
    print('StackTrace: $stack');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data. Please try again.')),
      );
    }
  }
}

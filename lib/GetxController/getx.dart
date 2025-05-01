import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitcoach/modelClass/mealItemList.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/utility/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Getx extends GetxController {
  RxInt isCom_select_Option = 0.obs;
  var selectedDays = 5.obs;

  RxInt pagesIndex = 0.obs;
  // RxDouble barValue = 0.1.obs;
  var selectedPreferences = <String>[].obs;
  RxString address = "".obs;
  late Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;
  late StreamSubscription<ConnectivityResult> _subscription;
  RxList mealItemList = [].obs;
  RxList userPostId = [].obs;

  var isFeetAndInches = false.obs;
  var feet = 0.obs;
  var inches = 0.obs;
  var cm = 0.obs;

  bool get isValidHeight => isFeetAndInches.value
      ? (feet.value > 0 || inches.value > 0)
      : cm.value > 0;
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  void onInit() {
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;

    _checkInitialConnectivity();

    // Listen for connectivity changes
    _subscription = _connectivityStream.listen((ConnectivityResult result) {
      _handleConnectivityChange(result);
    });
    super.onInit();
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _handleConnectivityChange(result);
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      Get.toNamed(
        AppRoutes.internetcheck,
      );
    } else {}
  }

  late SharedPreferences sp;
  Future<bool> isBioMatricEnable() async {
    sp = await SharedPreferences.getInstance();
    final data = sp.getBool('isAuthentication') ?? false;
    return data;
  }

  authBioMatric() async {
    bool auth = false;
    sp = await SharedPreferences.getInstance();
    try {
      auth = await localAuth.authenticate(
        authMessages: [],
        localizedReason: 'Authenticate using Face ID, fingerprint, or PIN.',
        options: const AuthenticationOptions(
          sensitiveTransaction: true,
          stickyAuth: true,
          useErrorDialogs: true, // Shows system authentication dialog
          biometricOnly: false, // Allows Face ID, fingerprint, and PIN/password
        ),
      );
    } catch (e) {
      auth = false;
    } finally {
      sp.setBool('isAuthentication', auth);

      print(auth);
      // ignore: control_flow_in_finally
      return auth;
    }
  }

  var mealItems = <MealItem>[].obs;

  void addMealItem(MealItem item) {
    mealItems.add(item);
  }

  void removeMealItem(MealItem item) {
    mealItems.remove(item);
  }

  void clearMealItems() {
    mealItems.clear();
  }

  void setMealItems(List<MealItem> items) {
    mealItems.value = items;
  }
}

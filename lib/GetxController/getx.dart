import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitcoach/utility/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Getx extends GetxController {
  RxInt isCom_select_Option = 0.obs;
  var selectedDays = 5.obs;
  // RxDouble barValue = 0.1.obs;
  var selectedPreferences = <String>[].obs;
  RxString address = "".obs;
  late Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;
  late StreamSubscription<ConnectivityResult> _subscription;
  // @override
  // void onClose() {
  //   decresebarValue();
  //   super.onClose();
  // }

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
    print(result);
    if (result == ConnectivityResult.none) {
      Get.to(() => NoInternetScreen());
    } else {
      // Get.back();
    }
  }
}

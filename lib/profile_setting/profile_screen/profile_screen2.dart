import 'dart:developer';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/profile_setting/profile_screen/finger_print_setup.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../Comprehensive_screen/com_screen2.dart';

class ProfileScreen2 extends StatefulWidget {
  @override
  _ProfileScreen2State createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {
  // String accountType = "Coach";
  double weight = 50;
  String gender = "Trans Female";
  Getx getx = Get.put(Getx());
  final List<String> genders = ['Male', 'Female', 'Trans Female', 'Non-Binary'];
  final List<String> locations = [
    'Location permission permanently denied.',
    'New York, USA',
    'London, UK',
    'Paris, France'
  ];
  String selectedGender = 'Trans Female';
  String selectedLocation = 'Location permission permanently denied.';

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => location = "Location services are disabled.");
        return;
      }

      // Check permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => location = "Location permission denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => location = "Location permission permanently denied.");
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        location =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });

      log(location);

      // Convert coordinates to an address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      // setState(() {
      getx.address.value =
          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      // });

      log("Address: ${getx.address.value}");
    } catch (e) {
      log(e.toString());
      getx.address.value = 'No location found';
    }
  }

  String location = "No location found";
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          "Profile Setup",
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_rounded,
                color: AppColors.textDark,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),

                // Profile Picture
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/profile/img1.png"),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: AppColors.primaryorange,
                          radius: 16,
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.textLight,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  "Full Name",
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Full Name Field
                TextField(
                  style: TextStyle(color: AppColors.textDark),
                  decoration: InputDecoration(
                    fillColor: AppColors.gray10,
                    filled: true,
                    // labelText: "Full Name",
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                    hintText: "Makise Kurisu",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.person, color: AppColors.textDark),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19),
                      borderSide: BorderSide(
                        color: AppColors.primaryorange,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  "Email Address",
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 5),

                // Email Address Field
                TextField(
                  style: TextStyle(color: AppColors.textDark),
                  decoration: InputDecoration(
                    fillColor: AppColors.gray10,
                    filled: true,
                    // labelText: "Email Address",
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                    hintText: "elementary221b@gmail.com",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.email,
                      color: AppColors.textDark,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19),
                      borderSide: BorderSide(
                        color: AppColors.primaryorange,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  "Password",
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Password Field
                TextField(
                  style: TextStyle(color: AppColors.textDark),
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: AppColors.gray10,
                    filled: true,
                    // labelText: "Password",
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                    hintText: "********",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColors.textDark,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19),
                      borderSide: BorderSide(
                        color: AppColors.primaryorange,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Account Type Selector

                SizedBox(height: 16),

                // Weight Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Weight",
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "${weight.toStringAsFixed(1)} kg",
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textScaler: TextScaler.linear(2),
                ),

                // Continue Button
                SizedBox(height: 16),

                const Text(
                  'Gender',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.gray10,
                    borderRadius: BorderRadius.circular(19),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<String>(
                    dropdownColor: AppColors.gray10,
                    value: selectedGender,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textDark),
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                    items: genders
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Row(
                                children: [
                                  const Icon(Icons.transgender,
                                      color: AppColors.textDark),
                                  const SizedBox(width: 10),
                                  Text(
                                    gender,
                                    style: const TextStyle(
                                        color: AppColors.textDark),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                // Location Dropdown
                const Text(
                  'Location',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.gray10,
                    borderRadius: BorderRadius.circular(19),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.textDark),
                      const SizedBox(width: 10),
                      Container(
                        width: MediaQuery.sizeOf(context).width - 100,
                        child: Obx(
                          () => getx.address.value != ''
                              ? Text(
                                  getx.address.value,
                                  style: const TextStyle(
                                      color: AppColors.textDark),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.save, color: AppColors.textLight),
                        Text(
                          "Save Settings",
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountTypeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountTypeButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

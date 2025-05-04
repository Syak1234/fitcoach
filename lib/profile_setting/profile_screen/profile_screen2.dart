import 'dart:developer';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
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
  RxString weightUnit = "kg".obs;
  RxBool isExperienced = false.obs;
  // double weight = 50;
  // RxString usergender = "Trans Female".obs;

  Getx getx = Get.put(Getx());
  final List<String> genders = ['Male', 'Female', 'Trans Female', 'Non-Binary'];
  final List<String> fitnessGoalList = [
    "I wanna lose weight",
    "I wanna get bulks",
    "I wanna gain endurance",
    "Just trying out the app! 👍"
  ];

  final List<String> dietList = [
    'Plant Based',
    'Carbo Diet',
    'Specialized',
    'Traditional'
  ];

  final List<String> locations = [
    'Location permission permanently denied.',
    'New York, USA',
    'London, UK',
    'Paris, France'
  ];

  final List<String> sleepQuality = [
    ">8 hours",
    "7-8 hours",
    "6-7 hours",
    "3-4 hours",
    "<2 hours"
  ];
  final List<String> daysCommit = ["1", "2", "3", "4", "5", "6", "7"];

  String selectedGender = 'Female';
  RxString selectedFitnessGoal = "I wanna lose weight".obs;
  RxString selectedDiet = "Plant Based".obs;
  RxString selectedDay = "1".obs;
  RxString selectedSleep = "7-8 hours".obs;

  String selectedLocation = 'Location permission permanently denied.';

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      weightUnit.value = await SharedPrefHelper.getString("weightUnit") ?? "kg";
      getx.selectedweightUnit.value =
          await SharedPrefHelper.getString("weightUnit") ?? "kg";

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
    getProfileDetails();
    // selectedGender = getx.userAssessmentDetaiils[0].gender;
    // selectedFitnessGoal.value = getx.userAssessmentDetaiils[0].fitnessGoal;
    // selectedDiet.value = getx.userAssessmentDetaiils[0].specificDiet;
    // selectedDay.value = getx.userAssessmentDetaiils[0].daysCommit;
    // isExperienced.value =
    //     getx.userAssessmentDetaiils[0].previousFitnessExperience == "true"
    //         ? true
    //         : false;
    // selectedSleep.value = getx.userAssessmentDetaiils[0].sleepQuality;
    _getCurrentLocation();

    super.initState();
  }

  getProfileDetails() {
    try {
      selectedGender = getx.userAssessmentDetaiils[0].gender;
      selectedFitnessGoal.value = getx.userAssessmentDetaiils[0].fitnessGoal;
      selectedDiet.value = getx.userAssessmentDetaiils[0].specificDiet;
      selectedDay.value = getx.userAssessmentDetaiils[0].daysCommit;
      isExperienced.value =
          getx.userAssessmentDetaiils[0].previousFitnessExperience == "true"
              ? true
              : false;
      selectedSleep.value = getx.userAssessmentDetaiils[0].sleepQuality;

      getx.selectedWeight.value = getx.userAssessmentDetaiils[0].weight;
      getx.selectedHeight.value = getx.userAssessmentDetaiils[0].height;
    } catch (e) {
      log(e.toString());
    }
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
                  enabled: false,
                  style: TextStyle(color: AppColors.textDark),
                  decoration: InputDecoration(
                    fillColor: AppColors.gray10,
                    filled: true,
                    // labelText: "Full Name",
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                    hintText:
                        "${getx.userdetails[0].username.replaceAll("@gmail.com", "")}",
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
                  enabled: false,
                  style: TextStyle(color: AppColors.textDark),
                  decoration: InputDecoration(
                    fillColor: AppColors.gray10,
                    filled: true,
                    // labelText: "Email Address",
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                    hintText: "${getx.userdetails[0].username}",
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
                  enabled: false,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weight",
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Obx(
                          () => Text(
                            "${getx.selectedWeight} ${getx.selectedweightUnit}",
                            style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            textScaler: TextScaler.linear(2),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          getx.forUpdate.value = true;
                          Get.toNamed(
                            AppRoutes.comScreen3,
                          );
                        },
                        child: Icon(Icons.edit)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Height",
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          getx.selectedHeight.value.contains("cm")
                              ? "${getx.selectedHeight.value}"
                              : "${getx.selectedHeight.value} cm",
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textScaler: TextScaler.linear(2),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          getx.forUpdate.value = true;
                          Get.toNamed(
                            AppRoutes.height,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.edit),
                        ))
                  ],
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
                // SizedBox(height: 16),

                const Text(
                  'Fitness Goal',
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
                    value: selectedFitnessGoal.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textDark),
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        selectedFitnessGoal.value = value!;
                      });
                    },
                    items: fitnessGoalList
                        .map((goals) => DropdownMenuItem(
                              value: goals,
                              child: Row(
                                children: [
                                  const Icon(Icons.fitness_center,
                                      color: AppColors.textDark),
                                  const SizedBox(width: 10),
                                  Text(
                                    goals,
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

                const Text(
                  'Specific Diet',
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
                    value: selectedDiet.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textDark),
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        selectedDiet.value = value!;
                      });
                    },
                    items: dietList
                        .map((diet) => DropdownMenuItem(
                              value: diet,
                              child: Row(
                                children: [
                                  const Icon(Icons.restaurant,
                                      color: AppColors.textDark),
                                  const SizedBox(width: 10),
                                  Text(
                                    diet,
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

                const Text(
                  'Commit Days ',
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
                    value: selectedDay.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textDark),
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        selectedDay.value = value!;
                      });
                    },
                    items: daysCommit
                        .map((day) => DropdownMenuItem(
                              value: day,
                              child: Row(
                                children: [
                                  const Icon(Icons.trip_origin,
                                      color: AppColors.textDark),
                                  const SizedBox(width: 10),
                                  Text(
                                    day + "x",
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

                Obx(
                  () => _buildSettingsItem(
                      Icons.run_circle_outlined,
                      isExperienced.value
                          ? "Yes, I am experienced"
                          : "No, I am not experienced ", onChanged: (val) {
                    isExperienced.value = val!;
                  }, switchValue: isExperienced.value),
                ),
                const SizedBox(height: 20),
                Text(
                  "Caloriey Goal",
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${getx.userAssessmentDetaiils[0].calorieyGoal} kcal",
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textScaler: TextScaler.linear(2),
                    ),
                    Icon(Icons.edit)
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Sleep Quality',
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
                    value: selectedSleep.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textDark),
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        selectedSleep.value = value!;
                      });
                    },
                    items: sleepQuality
                        .map((sleep) => DropdownMenuItem(
                              value: sleep,
                              child: Row(
                                children: [
                                  const Icon(
                                      Icons.airline_seat_individual_suite,
                                      color: AppColors.textDark),
                                  const SizedBox(width: 10),
                                  Text(
                                    sleep,
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
                //  const SizedBox(height: 20),

                const Text(
                  'Specific Experience Preferance ',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      color: AppColors.gray10,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.directions_run_rounded,
                              color: AppColors.textDark),
                          const SizedBox(width: 10),
                          Container(
                            width: 200,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              getx.userAssessmentDetaiils[0]
                                  .specificExperiencePreferance
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", ""),
                              style: const TextStyle(color: AppColors.textDark),
                            ),
                          ),
                          Icon(Icons.edit, color: AppColors.textDark),
                        ],
                      ),
                    )),
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

Widget _buildSettingsItem(
  IconData icon,
  String title, {
  bool isDanger = false,
  bool isButtonOnRight = true,
  bool switchValue = false,
  void Function()? ontap,
  void Function(bool)? onChanged,
}) {
  final trailingWidget = Switch(
    value: switchValue,
    onChanged: onChanged,
    activeTrackColor: AppColors.textLight,
    inactiveTrackColor: AppColors.textLight,
    activeColor: AppColors.primaryorange,
  );

  return InkWell(
    onTap: ontap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDanger ? AppColors.red : AppColors.gray10,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isButtonOnRight
            ? [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDanger
                            ? AppColors.red10.withOpacity(0.5)
                            : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: 48,
                      height: 48,
                      child: Icon(
                        icon,
                        color:
                            isDanger ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isDanger ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                trailingWidget,
              ]
            : [
                trailingWidget,
                const SizedBox(width: 12),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDanger
                            ? AppColors.red10.withOpacity(0.5)
                            : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: 48,
                      height: 48,
                      child: Icon(
                        icon,
                        color:
                            isDanger ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isDanger ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
      ),
    ),
  );
}

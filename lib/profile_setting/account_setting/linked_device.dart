import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkedDevicesScreen extends StatefulWidget {
  const LinkedDevicesScreen({super.key});

  @override
  State<LinkedDevicesScreen> createState() => _LinkedDevicesScreenState();
}

class _LinkedDevicesScreenState extends State<LinkedDevicesScreen> {
  int currentIndex = 0;
  final List<Map<String, String>> devices = [
    {"name": "Xiaomi Watch 8", "image": "assets/watch.png", "battery": "98%"},
    {
      "name": "Apple Watch Series 7",
      "image": "assets/apple_watch.png",
      "battery": "87%"
    },
  ];

  void changeDevice(int direction) {
    setState(() {
      currentIndex = (currentIndex + direction) % devices.length;
      if (currentIndex < 0) {
        currentIndex = devices.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: AppColors.gray10,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.arrow_back,
                          size: 24, color: AppColors.textDark),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Linked Devices",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/utility/watch.png',
                      width: 330,
                      height: 300,
                    ),
                    const SizedBox(height: 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Image.asset("assets/utility/left_arrow.png",
                              width: 40),
                          onPressed: () => changeDevice(-1),
                        ),
                        // Image.asset(
                        //   devices[currentIndex]["image"]!,
                        //   width: 200,
                        // ),
                        IconButton(
                          icon: Image.asset("assets/utility/right_arrow.png",
                              width: 40),
                          onPressed: () => changeDevice(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(devices[currentIndex]["name"]!,
                        textScaler: TextScaler.linear(1),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.primaryBlue, size: 18),
                        const SizedBox(width: 5),
                        Text("Connected",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 10),
                        const Icon(Icons.bolt,
                            color: AppColors.primaryorange, size: 18),
                        const SizedBox(width: 5),
                        Text(
                          devices[currentIndex]["battery"]!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundDark,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(Icons.tune,
                                  color: AppColors.textLight),
                            ),
                            onPressed: () {},
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundDark,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.link,
                                    color: AppColors.textLight,
                                    size: 56,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundDark,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(Icons.settings,
                                  color: AppColors.textLight),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

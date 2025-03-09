import 'dart:developer';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/meal_create/mealUi/customMealsScreen.dart';
import 'package:fitcoach/meal_create/mealUi/mealList.dart';
import 'package:fitcoach/profile_setting/account_setting/account_dashboard.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/workout/workout_homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard.dart';

class DashboardBottom extends StatefulWidget {
  const DashboardBottom({super.key});

  @override
  State<DashboardBottom> createState() => _DashboardBottomState();
}

class _DashboardBottomState extends State<DashboardBottom> {
  List pages = [
    HomeScreen(),
    WorkoutScreen(),
    CustomMealsScreen(),
    AccountDashboard()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Getx getx = Get.put(Getx());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return pages[getx.pagesIndex.value];
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryorange,
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(31)),
        child: const Icon(Icons.add, size: 28, color: AppColors.textLight),
        onPressed: () {
          // Action for FAB
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});
  Getx getx = Get.put(Getx());
  // RxInt _selectedIndex = 0.obs;

  void _onItemTapped(int index) {
    log(getx.pagesIndex.value.toString());
    getx.pagesIndex.value = index;

    // switch (index) {
    //   case 3:
    //     Get.to(() => AccountDashboard());
    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 80,

      // surfaceTintColor: Colors.white,
      color: AppColors.backgroundLight,
      shape: const CircularNotchedRectangle(),
      // shape: AutomaticNotchedShape(ShapeBorder.lerp(a, b, t)),

      notchMargin: 10,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.fitness_center, 1),
            const SizedBox(width: 50), // Space for FAB
            _buildNavItem(Icons.restaurant, 2),
            _buildNavItem(Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 26,
                  color: getx.pagesIndex.value == index
                      ? AppColors.textDark
                      : AppColors.gray),
              if (getx.pagesIndex.value == index)
                Container(
                  width: 30,
                  height: 4,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                      color: AppColors.primaryorange,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

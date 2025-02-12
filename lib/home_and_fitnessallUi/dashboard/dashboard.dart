import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray10,
      appBar: customAppBar(),
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

  PreferredSizeWidget customAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(200),
      child: Stack(
        children: [
          // Background Image
          Container(
            height: 214,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              image: DecorationImage(
                image:
                    AssetImage("assets/homeScreen/homescreen_appbar_img.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // AppBar Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Icons Row
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date Icon + Date
                      Row(
                        children: [
                          const Icon(Icons.calendar_month,
                              color: AppColors.textLight, size: 18),
                          const SizedBox(width: 6),
                          Text("JUN 25, 2025",
                              style: TextStyle(
                                  color: AppColors.textLight.withOpacity(0.7),
                                  fontSize: 14)),
                        ],
                      ),

                      // Notification Bell with Badge
                      badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -4, end: -4),
                        badgeContent: const Text("8",
                            style: TextStyle(
                                color: AppColors.textLight, fontSize: 12)),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: AppColors.primaryorange,
                          padding: EdgeInsets.all(6),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.notifications,
                              color: AppColors.textLight, size: 22),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // User Profile & Greeting
                  Row(
                    children: [
                      // Profile Picture
                      const CircleAvatar(
                        radius: 28,
                      ),
                      const SizedBox(width: 12),

                      // Greeting Text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello, Makise!",
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Health and Pro Status
                          Row(
                            children: [
                              const Icon(Icons.local_fire_department,
                                  color: AppColors.primaryorange, size: 16),
                              const SizedBox(width: 4),
                              const Text("88% Healthy",
                                  style: TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 14)),
                              const SizedBox(width: 8),
                              const Icon(Icons.star,
                                  color: AppColors.primaryBlue, size: 16),
                              const SizedBox(width: 4),
                              const Text("Pro",
                                  style: TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 14)),
                            ],
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Forward Arrow Icon
                      const Icon(Icons.arrow_forward_ios,
                          color: AppColors.textLight, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  RxInt _selectedIndex = 0.obs;

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
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
                  color: _selectedIndex.value == index
                      ? AppColors.textDark
                      : AppColors.gray),
              if (_selectedIndex.value == index)
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

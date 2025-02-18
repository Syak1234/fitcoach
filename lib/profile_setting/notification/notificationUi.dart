import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  PreferredSizeWidget customAppBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Stack(
        children: [
          // Background Image
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
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
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back,
                                color: AppColors.textLight, size: 18),
                            const SizedBox(width: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ), // Spacer(),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Notifications",
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionTitle("Earlier Today (8)"),
                _notificationItem(
                  icon: Icons.message,
                  iconColor: Colors.grey,
                  title: "Unread AI Chatbot Messages",
                  subtitle: "8 new Messages from sandow.ai!",
                  badgeCount: 8,
                ),
                _notificationItem(
                  icon: Icons.add_circle,
                  iconColor: Colors.orange,
                  title: "Score Increased!",
                  subtitle: "Sandow Score is now 87",
                ),
                _notificationItem(
                  icon: Icons.water_drop,
                  iconColor: Colors.blue,
                  title: "Drink More Water!",
                  subtitle: "You need to drink 1500ml left.",
                ),
                _notificationItem(
                  icon: Icons.fitness_center,
                  iconColor: Colors.green,
                  title: "Workout Complete!",
                  subtitle: "Upper Body Set Completed.",
                ),
                const SizedBox(height: 16),
                _sectionTitle("Past"),
                _notificationItem(
                  icon: Icons.directions_run,
                  iconColor: Colors.grey,
                  title: "Jogging Completed!",
                  subtitle: "You burned total 218kcal",
                  extraWidget:
                      const Icon(Icons.check_circle, color: Colors.white),
                ),
                _notificationItem(
                  icon: Icons.fitness_center,
                  iconColor: Colors.grey,
                  title: "Workout Completed!",
                  subtitle: "Chest Press completed",
                  extraWidget:
                      const Icon(Icons.check_circle, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: AppColors.gray,
              ))
        ],
      ),
    );
  }

  Widget _notificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? extraWidget,
    int badgeCount = 0,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundColor: iconColor,
                radius: 22,
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      "$badgeCount",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

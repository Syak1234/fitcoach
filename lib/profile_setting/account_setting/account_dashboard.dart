import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/home_and_fitnessallUi/dashboard/dashboard.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/app_colors.dart';

class AccountDashboard extends StatefulWidget {
  AccountDashboard({super.key});

  @override
  State<AccountDashboard> createState() => _AccountDashboardState();
}

class _AccountDashboardState extends State<AccountDashboard> {
  RxBool ischange = false.obs;
  Getx getx = Get.put(Getx());
  @override
  void initState() {
    callData();
    // TODO: implement initState
    super.initState();
  }

  callData() async {
    ischange.value = await getx.isBioMatricEnable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('General'),
            _buildSettingsItem(
              Icons.notifications,
              'Notifications',
              ontap: () {
                Get.toNamed(AppRoutes.notification);
              },
            ),
            _buildSettingsItem(
              Icons.person,
              'Personal Information',
              ontap: () {
                Get.toNamed(AppRoutes.profilescreen1);
              },
            ),
            // _buildSettingsItem(Icons.call, 'Coach Contact', trailing: '15+'),
            // _buildSettingsItem(Icons.language, 'Language',
            //     trailing: 'English (EN)'),
            // _buildSettingsItem(Icons.dark_mode, 'Dark Mode', switchValue: true),
            _buildSettingsItem(
              Icons.devices,
              'Linked Devices',
              trailing: 'Apple Watch',
              ontap: () {
                Get.toNamed(AppRoutes.linkDevice);
              },
            ),
            // _buildSettingsItem(Icons.emoji_events, 'Achievements'),
            _buildSectionTitle('Security & Privacy', beta: true),
            _buildSettingsItem(Icons.security, 'Main Security'),
            Obx(
              () => _buildSettingsItem(
                Icons.fingerprint,
                'Enable Biometric',
                switchValue: ischange.value,
                onChanged: (p0) async {
                  if (p0 == true) {
                    ischange.value = await getx.authBioMatric();
                  } else {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.setBool("isAuthentication", false);
                    ischange.value = p0;
                  }
                },
              ),
            ),
            _buildSettingsItem(Icons.policy, 'Privacy Policy', trailing: '3+'),
            _buildSectionTitle('Help & Support'),
            _buildSettingsItem(
              Icons.info,
              'About Us',
              ontap: () {
                Get.toNamed(AppRoutes.aboutUs);
              },
            ),
            _buildSettingsItem(Icons.help, 'Help Center'),
            _buildSettingsItem(Icons.feedback, 'Submit Feedback'),
            _buildSectionTitle('Danger Zone', warning: true),
            // _buildSettingsItem(Icons.delete, 'Close Account', isDanger: true),
            _buildSectionTitle('Log Out'),
            _buildSettingsItem(Icons.logout, 'Sign Out'),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: const [
                  Text(
                    'Fitcoach v1.0.0',
                    style: TextStyle(
                        color: AppColors.textDark, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\u00A9 All Rights Reserved, 2025',
                    style: TextStyle(color: AppColors.gray, fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget customAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Stack(
        children: [
          // Background Image
          Container(
            height: 200,
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

                  Spacer(),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Account Settings",
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
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title,
      {bool beta = false, bool warning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          if (beta)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Beta',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.blue60,
                    fontWeight: FontWeight.bold),
              ),
            ),
          if (warning)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.red10,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Warning',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title,
      {String? trailing,
      bool? switchValue,
      bool isDanger = false,
      void Function()? ontap,
      void Function(bool)? onChanged}) {
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
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: isDanger
                          ? AppColors.red10.withOpacity(0.5)
                          : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(16)),
                  width: 48, height: 48,
                  // padding: EdgeInsets.all(10),
                  child: Icon(icon,
                      color:
                          isDanger ? AppColors.textLight : AppColors.textDark),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDanger ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
              ],
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                    fontWeight: FontWeight.bold),
              ),
            switchValue != null
                ? Switch(
                    value: switchValue,

                    onChanged: onChanged,

                    activeTrackColor: AppColors.textLight,
                    inactiveTrackColor: AppColors.textLight,
                    // overlayColor: WidgetStateColor.resolveWith(
                    //   (states) => Colors.black,
                    // ),
                    // thumbIcon: W,

                    activeColor: AppColors.primaryorange,
                  )
                : Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDanger ? AppColors.textLight : AppColors.gray,
                  ),
          ],
        ),
      ),
    );
  }
}

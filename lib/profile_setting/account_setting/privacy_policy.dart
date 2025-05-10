import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/home_and_fitnessallUi/dashboard/dashboard.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/app_colors.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  RxString privacyPolicy =
      "<center><p>Does not have any privacy policy</p></center>".obs;
  Getx getx = Get.put(Getx());
  @override
  void initState() {
    callData();
    // TODO: implement initState
    super.initState();
  }

  callData() async {
    privacyPolicy.value =
        await getInternalService(serviceName: 'Privacy Policy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(
          () => Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: privacyPolicy.value == ""
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              getx.loadingWidget.value
                  ? Center(child: CircularProgressIndicator())
                  : getx.loadingWidget.value == false &&
                          privacyPolicy.value == ""
                      ? Center(child: Text("Does not have any policy"))
                      : HtmlWidget(privacyPolicy.value),
            ], 
          ),
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
            height: 120,
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

                  // Spacer(),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back,
                              color: AppColors.textLight, size: 25),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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

void showSignoutConfirmDialog(BuildContext context, VoidCallback ontap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: const Text("Sign out",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.textLight,
            ),
            onPressed: ontap,
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}

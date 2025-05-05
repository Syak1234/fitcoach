import 'dart:developer';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/modelClass/userDetails.dart';
import 'package:fitcoach/profile_setting/account_setting/account_dashboard.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:fitcoach/utility/step_trackerUi.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Getx getx = Get.put(Getx());

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  RxString name = "".obs;
  RxString userImage = "".obs;
  getUserData() async {
    await getUserDetails();

    name.value = await SharedPrefHelper.getString('name') ??
        await SharedPrefHelper.getString('username') ??
        '';
    userImage.value = await SharedPrefHelper.getString('userimg') ?? '';

    getx.token.value = await SharedPrefHelper.getString('token') ?? '';

    Userdetails userdetails = Userdetails(
      userId: await SharedPrefHelper.getString('userid') ?? '',
      username: await SharedPrefHelper.getString('username') ?? '',
      token: await SharedPrefHelper.getString('token') ?? '',
    );

    if (getx.userdetails.length > 0) {
      getx.userdetails.clear();
    }

    getx.userdetails.add(userdetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Fitness Metrics',
                  style: TextStyle(
                      fontSize: AppFontSize.mediumfontSize - 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray80),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            FitnessMetricsWidget()
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget customAppBar() {
    DateTime now = DateTime.now();

    // Format the current date as "JUN 25, 2025"
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return PreferredSize(
      preferredSize: const Size.fromHeight(170),
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
          Obx(
            () => SafeArea(
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
                            Text(formattedDate,
                                style: TextStyle(
                                    color: AppColors.textLight.withOpacity(0.7),
                                    fontSize: 14)),
                          ],
                        ),

                        // Notification Bell with Badge
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.notification);
                          },
                          child: badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: -4, end: -4),
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
                                color:
                                    AppColors.backgroundDark.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.notifications,
                                  color: AppColors.textLight, size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // User Profile & Greeting
                    Row(
                      children: [
                        // Profile Picture
                        userImage.value != ""
                            ? CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(userImage.value),
                              )
                            : CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png')),
                        const SizedBox(width: 12),

                        // Greeting Text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 230,
                              child: Text(
                                "Hello, ${name.value}!",
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
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
          ),
        ],
      ),
    );
  }
}

class FitnessMetricsWidget extends StatelessWidget {
  final StepsController controller = Get.put(StepsController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Obx(
            () => _buildMetricCard(
              title: 'Steps',
              value: controller.todaySteps.value.toString(),
              subvalue: ' steps today',
              color: AppColors.primaryorange,
              icon: Icons.add,
              child: _buildStepChart(),
              onTap: () {
                Get.toNamed(AppRoutes.stepUi);
              },
            ),
          ),
          const SizedBox(width: 8),
          _buildMetricCard(
              title: 'Hydration',
              value: '781',
              subvalue: 'ml',
              color: AppColors.primaryBlue,
              icon: Icons.water_drop,
              child: _buildHydrationChart(),
              onTap: () {
                Get.toNamed(AppRoutes.hydrationScreen);
              },
              context: context),
          const SizedBox(width: 8),
          // _buildMetricCard(
          //     title: 'Calories',
          //     value: '1578',
          //     subvalue: 'kcal',
          //     color: AppColors.gray80,
          //     icon: Icons.local_fire_department,
          //     child: _buildCaloriesChart(),
          //     context: context),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      {required String title,
      required String value,
      required String subvalue,
      required Color color,
      required IconData icon,
      required Widget child,
      context,
      void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 194,
        width: 154,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Icon(icon, color: Colors.white, size: 18),
              ],
            ),
            SizedBox(height: 8),
            Center(
              child: Container(
                child: child,
                height: 100,
                width: 150,
              ),
            ),
            SizedBox(height: 8),
            RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: subvalue,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.mediumfontSize - 15))
                  ],
                  text: value,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.mediumfontSize - 5,
                  )),

              // value,

              // style: TextStyle(
              // color: Colors.white,
              // fontWeight: FontWeight.bold,
              // fontSize: AppFontSize.mediumfontSize - 10),
              // overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStepChart() {
  return Image.asset(
    'assets/utility/stepsChart.png',
    fit: BoxFit.fill,
  );
}

Widget _buildHydrationChart() {
  return Image.asset(
    'assets/utility/hydrationChart.png',
    fit: BoxFit.fill,
  );
}

Widget _buildCaloriesChart() {
  return Image.asset(
    'assets/utility/caloriesChart.png',
    fit: BoxFit.fill,
  );
}

//   Widget _buildLineChart() {
//     return LineChart(
//       LineChartData(
//         backgroundColor: Colors.transparent,
//         lineBarsData: [
//           LineChartBarData(
//             spots: [
//               FlSpot(0, 1),
//               FlSpot(1, 2.5),
//               FlSpot(2, 2),
//               FlSpot(3, 3),
//               FlSpot(4, 2.8),
//             ],
//             isCurved: true,
//             colors: [Colors.white],
//             dotData: FlDotData(show: false),
//           )
//         ],
//         borderData: FlBorderData(show: false),
//         gridData: FlGridData(show: false),
//         titlesData: FlTitlesData(show: false),
//       ),
//     );
//   }
// }

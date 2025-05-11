import 'dart:developer';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/api_url.dart';
import 'package:fitcoach/modelClass/stepandwatermodelclass.dart';
import 'package:fitcoach/modelClass/userDetails.dart';
import 'package:fitcoach/profile_setting/account_setting/account_dashboard.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:fitcoach/utility/step_trackerUi.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Getx getx = Get.put(Getx());

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

    getx.userdetails.value = [userdetails];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitness Metrics',
              style: TextStyle(
                fontSize: AppFontSize.mediumfontSize - 10,
                fontWeight: FontWeight.bold,
                color: AppColors.gray80,
              ),
            ),
            SizedBox(height: 8),
            FitnessMetricsWidget(),
            SizedBox(height: 16),
            SizedBox(
              // height: , // Set height for the chart
              child: HistoryCalendar(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget customAppBar() {
// Getx getx = Get.put(Getx());

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
            decoration: BoxDecoration(
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
                        //     InkWell(
                        //       onTap: () {
                        //         Get.toNamed(AppRoutes.notification);
                        //       },
                        //       child: badges.Badge(
                        //         position:
                        //             badges.BadgePosition.topEnd(top: -4, end: -4),
                        //         badgeContent: const Text("8",
                        //             style: TextStyle(
                        //                 color: AppColors.textLight, fontSize: 12)),
                        //         badgeStyle: const badges.BadgeStyle(
                        //           badgeColor: AppColors.primaryorange,
                        //           padding: EdgeInsets.all(6),
                        //         ),
                        //         child: Container(
                        //           padding: const EdgeInsets.all(8),
                        //           decoration: BoxDecoration(
                        //             color:
                        //                 AppColors.backgroundDark.withOpacity(0.4),
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //           child: const Icon(Icons.notifications,
                        //               color: AppColors.textLight, size: 22),
                        //         ),
                        //       ),
                        //     ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // User Profile & Greeting
                    Row(
                      children: [
                        // Profile Picture
                        getx.profileImageUrl.value != "null"
                            ? CircleAvatar(
                                backgroundColor: AppColors.primaryBlue,
                                radius: 31,
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(
                                      getx.profileImageFullUrl.value),
                                ),
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
                                Obx(
                                  () => Text(
                                      getx.bmi.value != ""
                                          ? "BMI: ${getx.bmi.value}"
                                          : "BMI:0",
                                      style: TextStyle(
                                          color: AppColors.textLight,
                                          fontSize: 14)),
                                ),
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

class LineChartSample extends StatelessWidget {
  final List<String> months;
  final List<double> values;

  const LineChartSample({
    super.key,
    required this.months,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    // Generate spots from values
    final spots = List.generate(
      values.length,
      (index) => FlSpot(index.toDouble(), values[index]),
    );

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (months.length - 1).toDouble(),
        minY: 0,
        maxY: values.reduce((a, b) => a > b ? a : b) + 1,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index < 0 || index >= months.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  // axisSide: meta.axisSide,
                  space: 8,
                  meta: meta, // Required meta parameter
                  child: Text(
                    months[index],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.deepPurple, width: 2),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.deepPurple,
            barWidth: 4,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.deepPurple.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class FitnessMetricsWidget extends StatelessWidget {
  Getx getx = Get.put(Getx());
  Future<void> fetchAndCheckTodayEntry() async {
    String userId = await SharedPrefHelper.getString('userid') ?? '';
    final Uri url =
        Uri.https(ApiUrl.baseUrl, '/api/DailyStepActivity/get-by-user/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['isSuccess'] == true && data['result'] is List) {
          final List<dynamic> results = data['result'];

          final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

          final matchingItem = results.firstWhere(
            (item) {
              final itemDate = item['date'];
              if (itemDate == null) return false;
              final String formattedItemDate =
                  DateFormat('yyyy-MM-dd').format(DateTime.parse(itemDate));
              return formattedItemDate == today;
            },
            orElse: () => null,
          );

          if (matchingItem != null) {
            print("Found match! ID: ${matchingItem['id']}");
            getx.steptodayid.value = matchingItem['id'].toString();
            Get.toNamed(AppRoutes.stepUi);
          } else {
            print("No entry found for today's date.");
          }
        } else {
          print("Invalid data structure.");
        }
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  final StepsController controller = Get.put(StepsController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // ✅ Center the cards
        crossAxisAlignment: CrossAxisAlignment.center,
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
                if (getx.steptodayid.value.isEmpty) {
                  fetchAndCheckTodayEntry();
                } else {
                  Get.toNamed(AppRoutes.stepUi);
                }
                //
              },
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => _buildMetricCard(
                title: 'Hydration',
                value: getx.waterList.length != 0
                    ? getx.waterList[0].water ?? "0"
                    : "0",
                subvalue: 'ml',
                color: AppColors.primaryBlue,
                icon: Icons.water_drop,
                child: _buildHydrationChart(),
                onTap: () {
                  Get.toNamed(AppRoutes.hydrationScreen);
                },
                context: context),
          ),
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

class HistoryCalendar extends StatefulWidget {
  @override
  HistoryCalendarState createState() => HistoryCalendarState();
}

class HistoryCalendarState extends State<HistoryCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, dynamic>? _selectedDayData;

  final Getx activityController = Get.put(Getx());

  @override
  void initState() {
    super.initState();
    _callApi();
  }

  Future<void> _callApi() async {
    String userId = await SharedPrefHelper.getString('userid') ?? '';
    await fetchStepAndWaterList(userId: userId);
  }

  Future<void> fetchStepAndWaterList({required String userId}) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final Uri url = Uri.https(ApiUrl.baseUrl,
          '/api/DailyStepActivity/GetStepAndActivityByUser/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        log(data.toString());

        if (data['result'] is Map<String, dynamic>) {
          final result = data['result'] as Map<String, dynamic>;

          final stepList = (result['dailyStepActivityList'] as List<dynamic>?)
                  ?.map((e) => StepActivity.fromJson(e))
                  .toList() ??
              [];

          final waterList = (result['dailyActivityList'] as List<dynamic>?)
                  ?.map((e) => WaterActivity.fromJson(e))
                  .toList() ??
              [];

          activityController.setStepList(stepList);
          activityController.setWaterList(waterList);

          if (_selectedDay != null) {
            _filterDataForSelectedDate();
          }
        } else {
          print('Unexpected result format');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e, stack) {
      print('Fetch error: $e');
      print('StackTrace: $stack');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data. Please try again.')),
        );
      }
    } finally {
      // if (context.mounted) Navigator.of(context).pop();
      Get.back();
    }
  }

  void _filterDataForSelectedDate() {
    try {
      if (_selectedDay == null) return;

      final formattedSelectedDate =
          DateFormat('yyyy-MM-dd').format(_selectedDay!);

      final stepData = activityController.stepList.firstWhereOrNull(
        (activity) =>
            activity.date != null &&
            DateFormat('yyyy-MM-dd').format(activity.date!) ==
                formattedSelectedDate,
      );

      final waterData = activityController.waterList.firstWhereOrNull(
        (activity) =>
            activity.date != null &&
            DateFormat('yyyy-MM-dd').format(activity.date!) ==
                formattedSelectedDate,
      );

      setState(() {
        _selectedDayData = {
          'step': stepData?.step ?? '0',
          'minutes': stepData?.minutes ?? '0',
          'km': stepData?.km ?? '0',
          'kcal': stepData?.kcal ?? '0',
          'water': waterData?.water ?? '0',
        };
      });
    } catch (e) {
      print('Error filtering selected date: $e');
      setState(() {
        _selectedDayData = {
          'step': '0',
          'minutes': '0',
          'km': '0',
          'kcal': '0',
          'water': '0',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedDayData != null)
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(bottom: 20),
              elevation: 4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoTile(Icons.directions_walk, 'Steps',
                        '${_selectedDayData?['step']}', Colors.blueAccent),
                    _infoTile(
                        Icons.timer,
                        'Minutes',
                        '${_selectedDayData?['minutes']} min',
                        Colors.orangeAccent),
                    _infoTile(Icons.map, 'Distance',
                        '${_selectedDayData?['km']} km', Colors.greenAccent),
                    _infoTile(Icons.local_fire_department, 'Calories Burned',
                        '${_selectedDayData?['kcal']} kcal', Colors.redAccent),
                    Divider(color: Colors.white12),
                    _infoTile(
                        Icons.local_drink,
                        'Water Intake',
                        '${_selectedDayData?['water']} ml',
                        Colors.lightBlueAccent),
                  ],
                ),
              ),
            ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _filterDataForSelectedDate();
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                  color: Colors.blueAccent, shape: BoxShape.circle),
              selectedDecoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              weekendTextStyle: TextStyle(color: Colors.white),
              defaultTextStyle: TextStyle(color: Colors.white),
              outsideTextStyle: TextStyle(color: Colors.grey),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value, Color? color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: Colors.white70, fontSize: 16)),
      trailing: Text(
        value,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

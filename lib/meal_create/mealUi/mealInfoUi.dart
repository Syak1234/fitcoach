import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/modelClass/mealItemList.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class NutritionSummaryScreen extends StatefulWidget {
  @override
  State<NutritionSummaryScreen> createState() => _NutritionSummaryScreenState();
}

class _NutritionSummaryScreenState extends State<NutritionSummaryScreen> {
  final Getx mealController = Get.put(Getx());
  late double fat = 0.0;
  double carbohydrates = 0.0;
  double proteins = 0.0;
  double kcal = 0.0;
  String servingSize = '';
  String dataSource = "";
  String productname = "";
  double proteinPercentage = 0.0;

  double fatPercentage = 0.0;
  double carbohydratePercentage = 0.0;
  @override
  void initState() {
    log(Get.arguments.toString());
    proteins = double.parse(Get.arguments['protein']);
    fat = double.parse(Get.arguments['fat']);
    carbohydrates = double.parse(Get.arguments['carbohydrates']);
    kcal = double.parse(Get.arguments['kcal']);
    servingSize = Get.arguments['servingSize'];
    dataSource = Get.arguments['dataSource'];
    productname = Get.arguments['name'];
    proteinPercentage =
        double.tryParse(Get.arguments['proteinPercentage'] ?? "0") ?? 0;
    fatPercentage = double.tryParse(Get.arguments['fatPercentage'] ?? "0") ?? 0;
    carbohydratePercentage =
        double.tryParse(Get.arguments['carbohydratePercentage'] ?? "0") ?? 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height - 180,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 100, // Adjust width as needed
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: TextFormField(
                        initialValue: servingSize.toString(),
                        decoration: InputDecoration(
                          border: InputBorder.none, // Removes default underline
                          isDense: true, // Reduces default padding
                          contentPadding:
                              EdgeInsets.zero, // Aligns text properly
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Serving Size',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton(
                      value: 'g',
                      items: [DropdownMenuItem(child: Text('g'), value: 'g')],
                      onChanged: (value) {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Data Source: $dataSource',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    'Nutritional information per $servingSize g',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Energy Summary',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                  color: AppColors.primaryBlue, value: fat),
                              PieChartSectionData(
                                  color: Colors.green, value: carbohydrates),
                              PieChartSectionData(
                                  color: AppColors.primaryorange,
                                  value: proteins),
                            ],
                          ),
                        ),
                      ),
                      Text('$kcal kcal',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        'Protein ($proteinPercentage%) - $proteins g\nNet Carbs ($carbohydratePercentage%) - $carbohydrates g\nFat ($fatPercentage%) - $fat g',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    final Map<String, dynamic> itemData = Get.arguments;
                    final newItem = MealItem.fromMap(itemData);
                    mealController.mealItems.add(newItem);
                    Get.back(); // Go back afte
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'ADD TO MEAL',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
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
            height: 130,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/homeScreen/homescreen_appbar_img.png"),
                fit: BoxFit.cover,
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Icons Row
                  // SizedBox(
                  //   height: 20,
                  // ),
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
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            // size: 20,
                            color: AppColors.textLight,
                          ))
                    ],
                  ),

                  // Spacer(),

                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                FlutterClipboard.copy(productname)
                                    .then((value) => print('copied'));
                              },
                              child: Text(
                                "⭐ $productname",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
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
}

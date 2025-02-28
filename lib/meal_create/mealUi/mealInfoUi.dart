import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class NutritionSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: Icon(Icons.arrow_back, color: Colors.black),
      //   title: Text(
      //     'Baby Spinach, Raw',
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      //   ),
      //   actions: [Icon(Icons.more_vert, color: Colors.black)],
      // ),
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
                        initialValue: '100',
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
                      'Data Source: NDPA',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nutritional information per 100 g',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
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
                                  color: AppColors.primaryBlue, value: 33),
                              PieChartSectionData(
                                  color: Colors.green, value: 44),
                              PieChartSectionData(
                                  color: AppColors.primaryorange, value: 23),
                            ],
                          ),
                        ),
                      ),
                      Text('22 kcal',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        'Protein (33%) - 2.9g\nNet Carbs (44%) - 1.0g\nFat (23%) - 0.6g',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "⭐ Baby Spinach, Raw",
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 20,
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
}

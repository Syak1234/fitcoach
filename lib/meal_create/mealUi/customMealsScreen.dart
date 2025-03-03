import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomMealsScreen extends StatefulWidget {
  const CustomMealsScreen({super.key});

  @override
  _CustomMealsScreenState createState() => _CustomMealsScreenState();
}

class _CustomMealsScreenState extends State<CustomMealsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> meals = [
    'Vegetable Salad',
    'Vegan Bowl',
    'Chicken Wrap',
    'Fruit Mix'
  ];
  RxList<String> filteredMeals = <String>[].obs;

  @override
  void initState() {
    super.initState();
    filteredMeals.value = List.from(meals);
    _searchController.addListener(_filterMeals);
  }

  void _filterMeals() {
    filteredMeals.value = meals
        .where((meal) =>
            meal.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.gray10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Obx(
              () => filteredMeals.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: filteredMeals.length,
                        itemBuilder: (context, index) {
                          return filteredMeals.isNotEmpty
                              ? Card(
                                  elevation: 0,
                                  color: AppColors.gray10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text(
                                      filteredMeals[index],
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textDark),
                                    onTap: () {},
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: screenWidth * 0.15,
                            height: screenWidth * 0.15,
                            decoration: BoxDecoration(
                              color: AppColors.primaryorange,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                              size: screenWidth * 0.07,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Create a Meal",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.02),
                                Text(
                                  "Save time logging your meals! Combine frequently consumed items into Meals for more efficient tracking.",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget customAppBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
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
                      // InkWell(
                      //   onTap: () {
                      //     // Get.back();
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.arrow_back,
                      //           color: AppColors.textLight, size: 18),
                      //       const SizedBox(width: 6),
                      //     ],
                      //   ),
                      // ),
                      const Text(
                        "Create Meal",
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.createMealScreen);
                          // _showCustomDialog(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add,
                                color: AppColors.textLight, size: 25),
                            const SizedBox(width: 6),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // Row(
                  //   children: [
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.end,
                  //       children: [
                  //         const Text(
                  //           "Create Meal",
                  //           style: TextStyle(
                  //             color: AppColors.textLight,
                  //             fontSize: 25,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //         const SizedBox(height: 4),
                  //       ],
                  //     ),
                  //   ],
                  // ),
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

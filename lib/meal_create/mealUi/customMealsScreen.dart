import 'dart:developer';

import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/meal_create/mealUi/mealList.dart';
import 'package:fitcoach/modelClass/mealItemList.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Rebuild on search input change
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            Expanded(
              child: FutureBuilder<List<Meal>>(
                future: allListMealApi(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildNoMealsWidget(screenWidth);
                  } else {
                    List<Meal> meals = snapshot.data!;
                    String query = _searchController.text.toLowerCase();

                    List<Meal> filteredMeals = meals.where((meal) {
                      return meal.mealName.toLowerCase().contains(query);
                    }).toList();

                    if (filteredMeals.isEmpty) {
                      return Center(
                        child: Text('No meals found for "$query"'),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredMeals.length,
                      itemBuilder: (context, index) {
                        final meal = filteredMeals[index];
                        return Card(
                          elevation: 0,
                          color: AppColors.gray10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(
                              meal.mealName,
                              style: TextStyle(color: AppColors.textDark),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: AppColors.textDark),
                            onTap: () {
                              Get.to(() => CreateMealScreen(
                                    mealItems: meal.mealItems,
                                    meal: meal,
                                    update: true,
                                  ));
                              // Navigate to meal details if needed
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMealsWidget(double screenWidth) {
    return Container(
      height: 150, // Set fixed height
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
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
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
    );
  }

  PreferredSizeWidget customAppBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: Stack(
        children: [
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          Get.to(() => CreateMealScreen(
                                meal: Meal(
                                    id: 0,
                                    mealName: '',
                                    userId: '',
                                    mealItems: []),
                                // meal: Get.arguments[
                                //     'meal'], // required argument from route
                                mealItems: Get.arguments ?? [],
                              ));
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
                  const Spacer(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

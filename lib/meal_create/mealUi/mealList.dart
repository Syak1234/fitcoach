import 'dart:developer';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/modelClass/mealItemList.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMealScreen extends StatefulWidget {
  final List<MealItem> mealItems; // List of MealItem
  final Meal? meal; // Nullable Meal
  bool update;

  CreateMealScreen({
    Key? key,
    this.mealItems = const [], // Default to empty list
    this.meal, // Nullable meal
    this.update = false,
  }) : super(key: key);

  @override
  State<CreateMealScreen> createState() => _CreateMealScreenState();
}

class _CreateMealScreenState extends State<CreateMealScreen> {
  final TextEditingController mealNameController = TextEditingController();
  final Getx mealController = Get.put(Getx());

  @override
  void initState() {
    super.initState();
    // Handle the case where 'meal' could be null
    mealNameController.text =
        widget.meal?.mealName ?? ''; // Default to empty string if null
    mealController.setMealItems(
        widget.mealItems ?? []); // Set the mealItems in the controller
  }

  GlobalKey<FormState> gk = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context, widget.meal!.id),
      body: Form(
        key: gk,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Required";
                      }
                    },
                    controller: mealNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.gray10,
                      hintText: 'Meal Name (Required)',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.gray10, width: 0.6),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Meal Items',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 10),
                  Container(
                    height: 420,
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.gray10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Button to add meal items
                        TextButton(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.foodSearchScreen),
                          child: Text(
                            '+ ADD MEAL ITEM',
                            style: TextStyle(
                              fontSize: AppFontSize.mediumfontSize - 12,
                              color: AppColors.primaryorange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(),
                        Obx(() {
                          // If the mealItems list is empty, show a message
                          if (mealController.mealItems.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Text(
                                  'No meal items added yet. Please add meal items.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.primaryorange,
                                  ),
                                ),
                              ),
                            );
                          }

                          // Replace SingleChildScrollView with ListView.builder for better performance
                          return Expanded(
                            child: ListView.builder(
                              itemCount: mealController.mealItems.length,
                              itemBuilder: (context, index) {
                                final item = mealController.mealItems[index];

                                return ListTile(
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.nutritionSummaryScreen,
                                      arguments: {
                                        'protein': item.protein,
                                        'fat': item.fat,
                                        'carbohydrates': item.carbohydrates,
                                        'kcal': item.kcal,
                                        'servingSize': item.servingSize,
                                        'dataSource': item.dataSource,
                                        'name': item.name,
                                        'proteinPercentage': double.tryParse(
                                                        item.proteinPercentage)
                                                    ?.isNaN ==
                                                true
                                            ? '0.00'
                                            : item.proteinPercentage,
                                        'fatPercentage':
                                            double.tryParse(item.fatPercentage)
                                                        ?.isNaN ==
                                                    true
                                                ? '0.00'
                                                : item.fatPercentage,
                                        'carbohydratePercentage':
                                            double.tryParse(item
                                                            .carbohydratePercentage)
                                                        ?.isNaN ==
                                                    true
                                                ? '0.00'
                                                : item.carbohydratePercentage,
                                      },
                                    );
                                  },
                                  title: Text(
                                    item.name ??
                                        'No Name', // Default to 'No Name' if null
                                    style: const TextStyle(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    item.dataSource ??
                                        'No Data Source', // Default if null
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      log(item.name ?? 'Item Name is null');
                                      mealController.removeMealItem(item);
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundDark,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19)),
                      ),
                      onPressed: () {
                        if (gk.currentState!.validate()) {
                          widget.update
                              ? updateMealApi(context,
                                  id: widget.meal!.id.toString(),
                                  mealname: mealNameController.text,
                                  mealController: mealController)
                              : createMealApi(context,
                                  mealname: mealNameController.text,
                                  mealController: mealController);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.update ? "Update" : "Save",
                              style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom Dialog for Deleting Meal Item
  void _showCustomDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: const Text("Delete?",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to delete the food"),
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
              onPressed: () {
                deleteMeal(context, id: id);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Custom AppBar Widget
  PreferredSizeWidget customAppBar(context, id) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(110),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      InkWell(
                        onTap: () {
                          _showCustomDialog(context, id);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppColors.red, size: 18),
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
                            "Create Meal",
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
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

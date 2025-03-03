import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/theme/font_Size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';

class CreateMealScreen extends StatelessWidget {
  final TextEditingController mealNameController = TextEditingController();
  final List<String> mealItems = <String>[];

  CreateMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
     
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.sizeOf(context).height,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
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
                      TextButton(
                        onPressed: () =>
                            Get.toNamed(AppRoutes.foodSearchScreen),
                        child: Text('+ ADD MEAL ITEM',
                            style: TextStyle(
                                fontSize: AppFontSize.mediumfontSize - 12,
                                color: AppColors.primaryorange,
                                fontWeight: FontWeight.bold)),
                      ),
                      Divider(),
                      mealItems.isEmpty
                          ? SizedBox(height: 50)
                          : Column(
                              children: mealItems
                                  .map((item) => ListTile(
                                        title: Text(item,
                                            style:
                                                TextStyle(color: Colors.black)),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              mealItems.remove(item),
                                        ),
                                      ))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Spacer(),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundDark,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19)),
                      ),
                      onPressed:
                          // selectedGender == null
                          //     ? null
                          // :
                          () {
                        Get.toNamed(AppRoutes.nutritionSummaryScreen);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Next",
                              style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: AppColors.textLight),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addMealItem(BuildContext context) {
    TextEditingController itemController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Meal Item'),
        content: TextField(
          controller: itemController,
          decoration: InputDecoration(hintText: 'Enter item name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (itemController.text.isNotEmpty) {
                mealItems.add(itemController.text);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: const Text(
            "Delete?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete the food",
            textAlign: TextAlign.justify,
          ),
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
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget customAppBar(context) {
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
                      InkWell(
                        onTap: () {
                          _showCustomDialog(context);
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

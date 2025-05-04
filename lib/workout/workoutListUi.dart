import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/utility/page_not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitcoach/api_url.dart';
import 'package:fitcoach/constant.dart';
import 'package:fitcoach/theme/app_colors.dart';
// import 'package:fitcoach/controllers/exercise_controller.dart';
// controllers/exercise_controller.dart
import 'package:get/get.dart';
import 'package:get/get.dart';

class AddExerciseController extends GetxController {
  final categories = [
    'All',
    'Back',
    'Biceps',
    'Chest',
    'Triceps',
    'Legs',
    'Shoulders',
    'Abs',
    'Excluded',
  ];

  var selectedCategory = 'All'.obs;
  var selectedExercises = <Map<String, dynamic>>[].obs;
  var exercises = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExercises();
  }

  void fetchExercises() async {
    isLoading(true);
    try {
      final data = await getAllWorkout(); // your API call
      exercises.assignAll(data);
    } catch (e) {
      print("Error fetching exercises: $e");
    } finally {
      isLoading(false);
    }
  }

  void toggleExercise(Map<String, dynamic> exercise) {
    if (selectedExercises.any((e) => e['id'] == exercise['id'])) {
      selectedExercises.removeWhere((e) => e['id'] == exercise['id']);
    } else {
      selectedExercises.add(exercise);
    }
  }
}

class AddExerciseScreen extends StatelessWidget {
  const AddExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddExerciseController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title:
            const Text('Add Exercise', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final selectedCategory = controller.selectedCategory.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) {
                    final category = controller.categories[index];
                    final isSelected = category == selectedCategory;
                    return GestureDetector(
                      onTap: () => controller.selectedCategory.value = category,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!controller.exercises.isEmpty) {
                return NotFoundScreen();
              }

              return ListView.builder(
                itemCount: controller.exercises.length,
                itemBuilder: (_, index) {
                  final exercise = controller.exercises[index];
                  final imageUrl =
                      "https://${ApiUrl.baseUrl}${exercise['imageUrl']}";
                  // final isSelected = controller.selectedExercises
                  //     .any((item) => item['id'] == exercise['id']);

                  return GestureDetector(
                    onTap: () => controller.toggleExercise(exercise),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              imageUrl,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              exercise['imageName'] ?? '',
                              style: const TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Obx(() {
                            final isSelected = controller.selectedExercises
                                .any((item) => item['id'] == exercise['id']);

                            return CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  isSelected ? Colors.blue : Colors.grey,
                              child: isSelected
                                  ? const Icon(Icons.check,
                                      size: 16, color: Colors.white)
                                  : null,
                            );
                          })
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() {
            if (controller.selectedExercises.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Selected Exercises:");
                  for (var e in controller.selectedExercises) {
                    print("${e["imageName"]} - ${e["imageUrl"]}");
                  }
                  // Get.toNamed(AppRoutes.workoutLogSet);
                }
                // Add functionality here
                ,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryorange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.play_circle,
                    //   color: AppColors.textLight,
                    //   size: 30,
                    // ),
                    Text(
                      'Add ${controller.selectedExercises.length} exercises',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),

              //  SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              // print("Selected Exercises:");
              // for (var e in controller.selectedExercises) {
              //   print("${e["imageName"]} - ${e["imageUrl"]}");
              // }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       backgroundColor: Colors.blue,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //     ),
              //     child: Text(
              //         'Add ${controller.selectedExercises.length} exercises'),
              //   ),
              // ),
            );
          }),
        ],
      ),
    );
  }
}

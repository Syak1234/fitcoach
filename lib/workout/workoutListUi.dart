import 'dart:developer';

import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/dbfunction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitcoach/api_url.dart';
import 'package:fitcoach/constant.dart';
import 'package:fitcoach/theme/app_colors.dart';

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
                      onTap: () {
                        log("Selected Category: $category");
                        controller.selectedCategory.value = category;
                      },
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
              // Filtering exercises based on selected category
              final filteredExercises =
                  controller.selectedCategory.value == 'All'
                      ? controller.exercises
                      : controller.exercises
                          .where((exercise) =>
                              exercise['type'].toString().toUpperCase() ==
                              controller.selectedCategory.value.toUpperCase())
                          .toList();

              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (filteredExercises.isEmpty) {
                return const Center(child: Text('No exercises found.'));
              }

              return ListView.builder(
                itemCount: filteredExercises.length,
                itemBuilder: (_, index) {
                  final exercise = filteredExercises[index];
                  final imageUrl =
                      "https://${ApiUrl.baseUrl}${exercise['imageUrl']}";

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
                onPressed: () async {
                  for (var e in controller.selectedExercises) {
                    final workout = {
                      'workoutname': e['imageName'] ?? '',
                      'kg': double.tryParse(e['kg'].toString()) ?? 1,
                      'reps': int.tryParse(e['reps'].toString()) ?? 1,
                      'sets': int.tryParse(e['sets'].toString()) ?? 1,
                      'workoutimg': e['imageUrl'] ?? '',
                    };

                    final result =
                        await WorkoutDatabase.instance.insertWorkout(workout);

                    if (result == -1) {
                      print(
                          "Duplicate entry not inserted: ${workout['workoutname']}");
                    } else {
                      print("Workout inserted: ${workout['workoutname']}");
                    }
                    final a = await WorkoutDatabase.instance.fetchAllWorkouts();
                    log(a.toString());
                  }

                  Get.back();
                  // Add additional functionality as needed
                },
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
            );
          }),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WorkoutLogSetScreen extends StatefulWidget {
  WorkoutLogSetScreen({super.key});

  @override
  State<WorkoutLogSetScreen> createState() => _WorkoutLogSetScreenState();
}

class _WorkoutLogSetScreenState extends State<WorkoutLogSetScreen> {
  int selectedIndex = 0;

  final List<String> workoutIcons = [
    'assets/workoutimg/workout1.png',
    'assets/workoutimg/workout1.png',
    'assets/workoutimg/workout1.png',
    'assets/workoutimg/workout1.png',
  ];

  void _showWorkoutPicker(BuildContext context) {
    int selectedSet = 1;
    int selectedRep = 1;
    int selectedKg = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.black,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 500,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Incline Dumbbell Press",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: AppColors.gray,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPicker("SETS", 1, 50, selectedSet, (value) {
                          setState(() => selectedSet = value);
                        }),
                        _buildPicker("REPS", 1, 100, selectedRep, (value) {
                          setState(() => selectedRep = value);
                        }),
                        _buildPicker("KG", 1, 455, selectedKg, (value) {
                          setState(() => selectedKg = value);
                        }),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: AppColors.gray80,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Remove",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.red)),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: AppColors.gray80,
                  ),
                  // const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Save",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue)),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPicker(String label, int min, int max, int selectedValue,
      ValueChanged<int> onChanged) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 280,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              perspective: 0.002,
              diameterRatio: 1.5,
              onSelectedItemChanged: (index) {
                onChanged(index + min); // Update selected value
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final value = index + min;
                  final isSelected = value == selectedValue;
                  log(selectedValue.toString());

                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryorange
                          : Colors.transparent,
                    ),
                    child: Text(
                      "$value $label",
                      style: TextStyle(
                        fontSize: isSelected ? 18 : 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.grey[500],
                      ),
                    ),
                  );
                },
                childCount: max - min + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // White background
      body: Column(
        children: [
          // Top Workout Image (Placeholder)
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Image.asset("assets/workoutimg/workout1.png",
                        fit: BoxFit.contain),
                  ),
                  Positioned(
                    top: 50,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black, size: 30),
                      onPressed: () {
                        // Close button functionality
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(workoutIcons.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? AppColors.primaryorange
                            : AppColors.gray10,
                        borderRadius: BorderRadius.circular(10),
                        border: selectedIndex == index
                            ? Border.all(
                                color: AppColors.primaryorange, width: 2)
                            : null,
                      ),
                      child: Image.asset(
                        workoutIcons[index],
                        width: 40,
                        height: 40,
                        color: AppColors.textDark,
                      ),
                    ),
                  );
                }),
                // SizedBox(width: 6),
                IconButton(
                    onPressed: () {
                      // Add button functionality here
                    },
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.blue,
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    // ),
                    icon: Icon(Icons.add)),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),
          // Exercise Details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Learning",
                  style: TextStyle(
                      color: AppColors.gray,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Deadlift",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "54 kg x 5 reps x 5 sets",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Circular Progress Indicators (for sets)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.black12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10), // Add spacing before button
                      child: ElevatedButton(
                        onPressed: () {
                          _showWorkoutPicker(context);
                          // Add edit functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              AppColors.primaryBlue, // Change color as needed
                        ),
                        child: const Text("Edit",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Log Set Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundDark,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("✓ LOG SET",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight)),
                      SizedBox(width: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Setup Section (Placeholder)
                // const Text(
                //   "Setup",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

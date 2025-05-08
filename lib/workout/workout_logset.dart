import 'dart:developer';

import 'package:fitcoach/constant.dart';
import 'package:fitcoach/dbfunction.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/workout/workoutListUi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class WorkoutLogSetScreen extends StatefulWidget {
  RxList<dynamic> workoutList;
  int index;

  WorkoutLogSetScreen(this.workoutList, this.index, {super.key});

  @override
  State<WorkoutLogSetScreen> createState() => _WorkoutLogSetScreenState();
}

class _WorkoutLogSetScreenState extends State<WorkoutLogSetScreen> {
  RxInt selectedIndex = 0.obs;
  RxString selcetedimg = "".obs;
  RxString selcetedworkoutname = "".obs;
  RxString selcetedkg = "".obs;
  RxString selcetedreps = "".obs;
  RxString selcetedsets = "".obs;
  RxInt id = 0.obs;

  @override
  Widget build(BuildContext context) {
    selcetedimg.value = widget.workoutList[widget.index]['workoutimg'];
    selcetedkg.value =
        (int.tryParse(widget.workoutList[widget.index]['kg'].toString()) ?? 0)
            .toString();
    selcetedreps.value =
        (widget.workoutList[widget.index]['reps'] ?? 0).toString();
    selcetedsets.value =
        (widget.workoutList[widget.index]['sets'] ?? 0).toString();
    selcetedworkoutname.value = widget.workoutList[widget.index]['workoutname'];
    id.value = widget.workoutList[widget.index]['id'];
    selectedIndex.value = widget.index;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Obx(() => Center(
                        child: Image.network(
                          Constant.imagebaseUrl + selcetedimg.value,
                          fit: BoxFit.contain,
                        ),
                      )),
                  Positioned(
                    top: 50,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black, size: 30),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(widget.workoutList.length, (index) {
                      final workout = widget.workoutList[index];
                      return GestureDetector(
                        onTap: () {
                          selectedIndex.value = index;
                          selcetedimg.value = workout['workoutimg'];
                          selcetedkg.value =
                              (int.tryParse(workout['kg'].toString()) ?? 0)
                                  .toString();
                          selcetedreps.value = workout['reps'].toString();
                          selcetedsets.value = workout['sets'].toString();
                          selcetedworkoutname.value =
                              workout['workoutname'].toString();
                          id.value = workout['id'];
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: selectedIndex.value == index
                                ? AppColors.primaryorange
                                : AppColors.gray10,
                            borderRadius: BorderRadius.circular(10),
                            border: selectedIndex.value == index
                                ? Border.all(
                                    color: AppColors.primaryorange, width: 2)
                                : null,
                          ),
                          child: Image.network(
                            Constant.imagebaseUrl + workout['workoutimg'],
                            width: 40,
                            height: 40,
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: () {
                        Get.to(() => AddExerciseScreen());
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                )),
          ),
          SizedBox(height: 10),
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Learning",
                        style: TextStyle(
                            color: AppColors.gray,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(selcetedworkoutname.value,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(
                      "${selcetedkg.value} kg x ${selcetedreps.value} reps x ${selcetedsets.value} sets",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...List.generate(
                            int.tryParse(selcetedsets.value) ?? 0,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: AppColors.primaryBlue,
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                showWorkoutPicker(context,
                                    workoutname: selcetedworkoutname.value,
                                    kg: int.tryParse(selcetedkg.value) ?? 1,
                                    reps: int.tryParse(selcetedreps.value) ?? 1,
                                    sets: int.tryParse(selcetedsets.value) ?? 1,
                                    onSave: (kg, reps, sets) {
                                  selcetedkg.value = kg.toString();
                                  selcetedreps.value = reps.toString();
                                  selcetedsets.value = sets.toString();
                                }, id: id.value, workoutimg: selcetedimg.value);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: AppColors.primaryBlue,
                              ),
                              child: const Text("Edit",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        toastification.show(
                          context: context,
                          title: const Text('Workout set saved successfully'),
                          autoCloseDuration: const Duration(seconds: 3),
                          type: ToastificationType.success,
                          style: ToastificationStyle.fillColored,
                        );
                      },
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
                    SizedBox(height: 10),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

void showWorkoutPicker(BuildContext context,
    {required String workoutname,
    required int kg,
    required int reps,
    required int sets,
    required Function(int kg, int reps, int sets) onSave,
    required int id,
    required String workoutimg}) {
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
                Text(workoutname,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Divider(thickness: 0.8, color: AppColors.gray),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildPicker("SETS", 1, 50, sets, (value) {
                        setState(() => sets = value);
                      }),
                      buildPicker("REPS", 1, 100, reps, (value) {
                        setState(() => reps = value);
                      }),
                      buildPicker("KG", 1, 455, kg, (value) {
                        setState(() => kg = value);
                      }),
                    ],
                  ),
                ),
                Divider(thickness: 0.8, color: AppColors.gray80),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showCrunchExcludeSheet(
                        context, workoutimg, workoutname, id);

                    //
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Remove",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.red)),
                ),
                Divider(thickness: 0.8, color: AppColors.gray80),
                ElevatedButton(
                  onPressed: () {
                    onSave(kg, reps, sets);
                    WorkoutDatabase.instance.updateWorkout({
                      'id': id,
                      'workoutname': workoutname,
                      'kg': kg,
                      'reps': reps,
                      "sets": sets,
                      "workoutimg": workoutimg
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Save",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue)),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget buildPicker(
  String label,
  int min,
  int max,
  int selectedValue,
  ValueChanged<int> onChanged,
) {
  final initialIndex = selectedValue - min;
  final controller = FixedExtentScrollController(initialItem: initialIndex);

  return Expanded(
    child: Column(
      children: [
        SizedBox(
          height: 280,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 50,
            perspective: 0.002,
            diameterRatio: 1.5,
            onSelectedItemChanged: (index) {
              onChanged(index + min);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final value = index + min;
                final isSelected = value == selectedValue;
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

void showCrunchExcludeSheet(BuildContext context, workoutimg, workoutname, id) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return CrunchExcludeSheet(
          workoutimg: workoutimg, workoutname: workoutname, id: id);
    },
  );
}

class CrunchExcludeSheet extends StatelessWidget {
  String workoutimg;
  String workoutname;
  int id;
  CrunchExcludeSheet(
      {required this.workoutimg,
      required this.workoutname,
      required this.id,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Bottom Sheet Body
        Container(
          margin: const EdgeInsets.only(top: 100),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.horizontal_rule, color: Colors.grey, size: 32),
              const SizedBox(height: 12),
              Image.network(
                Constant.imagebaseUrl + workoutimg,
                width: 100,
                height: 100,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              // Image.asset(
              //   'assets/crunch_icon.png', // Replace with your asset
              //   height: 60,
              // ),
              const SizedBox(height: 12),
              Text(
                "Exclude this in the future?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                workoutname,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              _optionButton("Exclude Forever", context, () {
                WorkoutDatabase.instance.deleteWorkout(
                  id,
                );
                Navigator.pop(context);
              }),
              _optionButton("Just for today", context, () {
                WorkoutDatabase.instance.deleteWorkout(
                  id,
                );
                Navigator.pop(context);
              }),
              _optionButton("Cancel", context, () {
                Navigator.pop(context);
              }, isCancel: true),
              const SizedBox(height: 12),
            ],
          ),
        ),
        // Top Muscle Image
        // Positioned(
        //   top: 0,
        //   child: Image.asset(
        //     'assets/crunch_top.png', // Replace with your asset
        //     height: 160,
        //   ),
        // ),
      ],
    );
  }

  Widget _optionButton(String text, BuildContext context, Function() param2,
      {bool isCancel = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextButton(
        onPressed: param2,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isCancel ? Colors.transparent : Colors.grey.shade800,
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: const Size(double.infinity, 0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isCancel ? Colors.blue : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

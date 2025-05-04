import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/workout/workoutListUi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const WorkoutMobileView(),
    );
  }
}

class WorkoutMobileView extends StatelessWidget {
  const WorkoutMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      //  AppBar(
      //   backgroundColor: Colors.black,
      //   title: RichText(
      //     text: const TextSpan(
      //       children: [
      //         TextSpan(
      //           text: "Fitcoach",
      //           style: TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.white,
      //           ),
      //         ),
      //         // TextSpan(
      //         //   text: "AI",
      //         //   style: TextStyle(
      //         //     fontSize: 20,
      //         //     fontWeight: FontWeight.bold,
      //         //     color: Colors.blueAccent,
      //         //   ),
      //         // ),
      //       ],
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notifications),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "TRY PREMIUM",
                  style: TextStyle(
                      color: AppColors.textLight, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _customButton("Equipment", Icons.fitness_center),
                _customButton("Muscle Groups", Icons.add),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "4 Exercises",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ExerciseTile(
                      title: "Deadlift",
                      weight: "64 kg",
                      reps: "5 reps",
                      sets: "5 sets",
                      icon: Icons.fitness_center),
                  ExerciseTile(
                      title: "Lat Pulldown",
                      weight: "50 kg",
                      reps: "8 reps",
                      sets: "4 sets",
                      icon: Icons.fitness_center),
                  ExerciseTile(
                      title: "Bench Press",
                      weight: "54 kg",
                      reps: "5 reps",
                      sets: "5 sets",
                      icon: Icons.fitness_center),
                  ExerciseTile(
                      title: "Barbell Curl",
                      weight: "32 kg",
                      reps: "8 reps",
                      sets: "4 sets",
                      icon: Icons.fitness_center),
                ],
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.to(() => AddExerciseScreen(),
                    transition: Transition.leftToRight);
              },
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primaryBlue,
                    ),
                    onPressed: () async {},
                  ),
                  const Text(
                    "Add Exercise",
                    style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.workoutLogSet);
              }
              // Add functionality here
              ,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle,
                    color: AppColors.textLight,
                    size: 30,
                  ),
                  Text(
                    ' Start Workout',
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _customButton(String text, IconData icon) {
    return Expanded(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.primaryorange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
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
                    ],
                  ),

                  Spacer(),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Fitcoach",
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

class ExerciseTile extends StatelessWidget {
  final String title;
  final String weight;
  final String reps;
  final String sets;
  final IconData icon;

  const ExerciseTile({
    Key? key,
    required this.title,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.gray10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.textDark,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          "$weight x $reps x $sets",
          style: const TextStyle(
            color: AppColors.gray80,
          ),
        ),
        trailing: const Icon(
          Icons.more_vert,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PostsScreen extends StatefulWidget {
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],

      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45.0),
                bottomRight: Radius.circular(45.0),
              ),
              color: AppColors.backgroundDark,
            ),
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Makise Kurisu",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: AppColors.backgroundLight)),
                          Text("25 posts",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255))),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.gray80,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Icon(
                            Icons.notifications,
                            color: AppColors.backgroundLight,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: PostCard(
                    username: 'Makise Kurisu',
                    time: '3m ago',
                    content:
                        "Just crushed my morning workout - a killer HIIT session to kickstart the day! 🚀 Feeling the burn in the best way possible. 💦🔥 #HIITWorkout #HealthyEating",
                    imageUrl:
                        'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: PostCard(
                    username: 'Makise Kurisu',
                    time: '3m ago',
                    content:
                        "Morning vibes! Just completed a refreshing yoga session to start the day on a positive note. 🧘‍♀️ How do you like to kick off your mornings? #YogaLove #WellnessWednesday",
                    imageUrl:
                        'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: buildContinueButton(),
      ),
    );
  }

  Widget buildContinueButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryorange,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      ),
      onPressed: () {
        Get.toNamed(AppRoutes.commmunityScreen3);
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Add new post",
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 28),
          Icon(Icons.add, color: AppColors.textLight),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String username;
  final String time;
  final String content;
  final String imageUrl;

  const PostCard({
    required this.username,
    required this.time,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppColors.gray10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(time, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(content),
            SizedBox(height: 10),
            Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gray),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Image.network(imageUrl)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_border),
                    SizedBox(width: 5),
                    Text('5,874'),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(width: 5),
                    Text('215'),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 5),
                    Text('11'),
                  ],
                ),
                Spacer(),
                Icon(Icons.bookmark_border),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

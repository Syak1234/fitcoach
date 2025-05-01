import 'package:fitcoach/Firebase_functions/firebasefunctions.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class PostsScreen extends StatefulWidget {
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Getx getx = Get.put(Getx());

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
                          Text(getx.userdetails[0].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: AppColors.backgroundLight)),
                          Obx(
                            () => Text("${getx.userPostId.length} posts",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255))),
                          ),
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
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No posts available.'));
                }

                final posts = snapshot.data!;

                return ListView(
                  reverse: false,
                  children: posts.map((post) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: getx.userdetails[0].userId ==
                                  post['userId'].toString()
                              ? 30
                              : 10,
                          right: getx.userdetails[0].userId !=
                                  post['userId'].toString()
                              ? 30
                              : 10,
                          top: 15,
                          bottom: 15),
                      child: PostCard(
                          content: post["text"] ?? "",
                          caption: post["caption"] ?? "No caption",
                          likeIdList: post['LikedId'] ?? [],
                          imageUrl: "",
                          postType: post['postType'],
                          time: post['postTime'].toString(),
                          username: post['username'] ?? "name not public",
                          userId: post['userId'],
                          postId: post['PostId'],
                          color: getx.userdetails[0].userId ==
                                  post['userId'].toString()
                              ? AppColors.primaryBlue
                              : AppColors.primaryorange),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
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
  final String postType;
  final String caption;
  final List likeIdList;
  final String userId;
  final String postId;
  final Color color;
  const PostCard({
    required this.username,
    required this.time,
    required this.content,
    required this.imageUrl,
    required this.postType,
    required this.caption,
    required this.likeIdList,
    required this.userId,
    required this.postId,
    required this.color,
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
            Wrap(
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: color)),
                    Text(processTimestampString(time),
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(caption),
            SizedBox(height: 10),
            postType != "text"
                ? Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Image.network(imageUrl))
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: content != ""
                            ? Border.all(color: AppColors.gray)
                            : null,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: content != ""
                          ? EdgeInsets.symmetric(vertical: 20, horizontal: 10)
                          : EdgeInsets.symmetric(vertical: 0),
                      child: Text("$content"),
                    )),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (likeIdList.contains(getx.userdetails[0].userId)) {
                            removeLikeFromPost(
                                postId, getx.userdetails[0].userId);
                          } else {
                            addLikeToPost(postId, getx.userdetails[0].userId);
                          }
                        },
                        child: likeIdList.contains(getx.userdetails[0].userId)
                            ? Icon(
                                Icons.favorite_outlined,
                                color: AppColors.red,
                              )
                            : Icon(Icons.favorite_border)),
                    SizedBox(width: 5),
                    Text('${likeIdList.length}'),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(width: 5),
                    Text('0'),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 5),
                    Text('0'),
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
// import 'package:intl/intl.dart';

String processTimestampString(String input) {
  final lowerInput = input.toLowerCase();

  if (lowerInput.contains('timestamp')) {
    final regex =
        RegExp(r'seconds=(\d+),\s*nanoseconds=(\d+)', caseSensitive: false);
    final match = regex.firstMatch(input);

    if (match != null) {
      int seconds = int.parse(match.group(1)!);
      int nanoseconds = int.parse(match.group(2)!);

      int milliseconds = seconds * 1000 + (nanoseconds ~/ 1000000);
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

      // Format to "07:36pm,16 apr,2025"
      String formatted =
          DateFormat('hh:mma,dd MMM,yyyy').format(dateTime).toLowerCase();

      return formatted;
    }
  }

  // If no timestamp or no match, return original string
  return input;
}

import 'dart:developer';

import 'package:fitcoach/Firebase_functions/firebasefunctions.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

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
                        radius: 38,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: getx.profileImageUrl.value == "null"
                              ? NetworkImage(
                                  'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png')
                              : NetworkImage(getx.profileImageFullUrl.value),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text(getx.userdetails[0].username,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: AppColors.backgroundLight)),
                          ),
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
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         color: AppColors.gray80,
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(15))),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 15, vertical: 15),
                      //     child: Icon(
                      //       Icons.notifications,
                      //       color: AppColors.backgroundLight,
                      //     ),
                      //   ),
                      // )
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
                          userId: post['userId'] ?? "",
                          postId: post['PostId'] ?? "",
                          color: getx.userdetails[0].userId ==
                                  post['userId'].toString()
                              ? AppColors.primaryBlue
                              : AppColors.primaryorange,
                          commentId: post['commentId'] ?? [],
                          imgurl: post['imgPath'] ?? ""),
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
  final List commentId;
  final String imgurl;
  const PostCard(
      {required this.username,
      required this.time,
      required this.content,
      required this.imageUrl,
      required this.postType,
      required this.caption,
      required this.likeIdList,
      required this.userId,
      required this.postId,
      required this.color,
      required this.commentId,
      required this.imgurl});

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
                  backgroundImage: imgurl == ""
                      ? NetworkImage(
                          'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png')
                      : NetworkImage(imgurl),
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
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) =>
                              CommentBottomSheet(postId: postId),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.comment),
                          SizedBox(width: 5),
                          Text(
                              "${commentId.length ?? 0}"), // You can replace '0' with the comment count later
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  width: 10,
                ),

                Spacer(),
                InkWell(
                  onTap: () {
                    String shareText =
                        "$caption\n\n$content\n \n\n Post shared from Fitcoach by ${getx.userdetails[0].username}";
                    if (postType != "text") {
                      shareText += "\n\nImage: $imageUrl";
                    }
                    Share.share(shareText);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 5),
                      // Text('Share'),
                    ],
                  ),
                ),
                // Icon(Icons.bookmark_border),
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

class CommentBottomSheet extends StatefulWidget {
  final String postId;

  CommentBottomSheet({required this.postId});

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  // Example data
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ;
    log(widget.postId.toString());
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom), // For keyboard
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: streamCommentsByPostId(widget.postId),
                builder: (context, snapshot) {
                  log('Stream state: ${snapshot.connectionState}');

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      (snapshot.data == null || snapshot.data!.isEmpty)) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final comments = snapshot.data ?? [];

                  if (comments.isEmpty) {
                    return const Center(child: Text('No Comments available.'));
                  }

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final isOwnComment = getx.userdetails[0].userId ==
                          comment['userId'].toString();

                      return Padding(
                        padding: EdgeInsets.only(
                          left: isOwnComment ? 30 : 10,
                          right: isOwnComment ? 10 : 30,
                          top: 15,
                          bottom: 15,
                        ),
                        child: InkWell(
                          onLongPress: () {
                            if (isOwnComment) {
                              showDeleteCommentDialog(
                                context: context,
                                commentId: comment['commentId'] ?? "",
                                postId: comment['postID'] ?? "",
                                // deleteComment: deleteComment,
                              );
                            }
                          },
                          child: CommentCard(
                            postId: comment["postID"] ?? "",
                            content: comment["comment"] ?? "",
                            likeIdList: comment['LikedId'] ?? [],
                            imageUrl: "",
                            time: comment['postTime'].toString(),
                            username: comment['username'] ?? "name not public",
                            userId: comment['userId'] ?? "",
                            commentId: comment['commentId'] ?? "",
                            color: isOwnComment
                                ? AppColors.primaryBlue
                                : AppColors.primaryorange,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_controller.text.trim().isNotEmpty) {
                      createComment(
                              getx.userdetails[0].userId,
                              _controller.text,
                              getx.userdetails[0].username,
                              widget.postId)
                          .then((val) {
                        if (val != "") {
                          Fluttertoast.showToast(
                              msg: "Comment added successfully!");
                          // Dismiss the keyboard
                          _controller.clear();
                        } else {
                          Fluttertoast.showToast(msg: "Something went Wrong!");
                          // Dismiss the keyboard
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final String postId;
  final String username;
  final String time;
  final String content;
  final String imageUrl;

  final List likeIdList;
  final String userId;
  final String commentId;
  final Color color;
  const CommentCard({
    required this.postId,
    required this.username,
    required this.time,
    required this.content,
    required this.imageUrl,
    required this.likeIdList,
    required this.userId,
    required this.commentId,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: const Color.fromARGB(255, 233, 228, 228)),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: color)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(processTimestampString(time),
                    style: TextStyle(color: Colors.grey)),
                Spacer(),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (likeIdList.contains(getx.userdetails[0].userId)) {
                            removeLikeFromComment(
                                commentId, getx.userdetails[0].userId);
                          } else {
                            addLikeToComment(
                                commentId, getx.userdetails[0].userId);
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

                // Icon(Icons.bookmark_border),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showDeleteCommentDialogold({
  required BuildContext context,
  required String commentId,
  required String postId,
  required Future<bool> Function(String commentId, String postId) deleteComment,
}) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete Comment'),
      content: Text('Are you sure you want to delete this comment?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            bool success = await deleteComment(commentId, postId);
            Navigator.of(context).pop();
            if (success) {
              Fluttertoast.showToast(msg: "Comment deleted!");
            } else {
              Fluttertoast.showToast(msg: "Failed to delete comment.");
            }
          },
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

void showDeleteCommentDialog({
  required BuildContext context,
  required String commentId,
  required String postId,
  // required Future<bool> Function(String commentId, String postId) deleteComment,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: const Text("Delete Comment",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this comment?'),
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
            onPressed: () async {
              bool success = await deleteComment(commentId, postId);
              Navigator.of(context).pop();
              if (success) {
                Fluttertoast.showToast(msg: "Comment deleted!");
              } else {
                Fluttertoast.showToast(msg: "Failed to delete comment.");
              }
            },
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}

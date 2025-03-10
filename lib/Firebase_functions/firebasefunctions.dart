// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/utility/resultDialoge.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

Getx getx = Get.put(Getx());
String userid = '111';

// Function to create user table (collection)
Future<bool> createUser(
    BuildContext context, String userId, String fullName, String email) async {
  bool success = false;
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await _firestore.collection('users').doc(userId).set({
      'userId': userId,
      'fullName': fullName,
      'email': email,
    });

    success = true;
    Navigator.of(context).pop();
  } catch (e) {
    success = false;
    Navigator.of(context).pop();
    print('Error creating user: $e');
    resultDialog(
        context: context,
        title: "Error",
        buttonText: "ok",
        icon: Icons.error,
        message: "Something went wrong!",
        iconBackgroundColor: AppColors.backgroundLight,
        onButtonPressed: () {
          Navigator.pop(context);
        });
  }
  return success;
}

// Function to create post table (collection)
Future<String?> createPost(String userId, String postType, String caption,
    String text, String username) async {
  String formattedTime =
      DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.now());
  try {
    DocumentReference docRef = await _firestore.collection('posts').add({
      'userId': userId,
      'username': username,
      'LikedId': [],
      'postType': postType,
      'caption': caption,
      'text': text,
      'likeCount': 0,
      'postTime': formattedTime,
    });

    String postId = docRef.id;

    await docRef.update({'PostId': postId});

    return postId; // Return the PostId if successful
  } catch (e) {
    print('Error creating post: $e');
    return null; // Return null if there's an error
  }
}

Future<void> addLikeToPost(String postId, String userId) async {
  try {
    // Get the reference to the post document using postId
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);

    // Update the LikedId array field with the new userId
    await postRef.update({
      'LikedId':
          FieldValue.arrayUnion([userId]), // Add userId to the LikedId array
    });

    print('User added to LikedId list successfully');
  } catch (e) {
    print('Error adding like: $e');
  }
}

Future<void> removeLikeFromPost(String postId, String userId) async {
  try {
    // Get the reference to the post document using postId
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);

    // Remove userId from the LikedId array field
    await postRef.update({
      'LikedId': FieldValue.arrayRemove(
          [userId]), // Remove userId from the LikedId array
    });

    print('User removed from LikedId list successfully');
  } catch (e) {
    print('Error removing like: $e');
  }
}

Stream<List<Map<String, dynamic>>> fetchPosts() {
  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('postTime',
          descending: true) // Order by postTime for the latest posts
      .snapshots()
      .map((snapshot) {
    // Filter posts where the userId matches the given userId
    List<Map<String, dynamic>> allPosts =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // Now, we can filter the posts by userId (replace 'userid' with your actual variable)
    getx.userPostId.value = allPosts
        .where((post) => post['userId'] == userid) // Filter by userId
        .map((post) => post['PostId'] as String) // Extract postId
        .toList();

    // Return all posts (or any other operation you want)
    return allPosts;
  });
}

Future<String> fetchUserDetails(String userId) async {
  try {
    // Fetch the user document using the userId
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') // Assuming your collection is named 'users'
        .doc(userId) // Fetch the document with the userId
        .get();

    if (userDoc.exists) {
      // Extract user details (email and fullName)
      String email =
          userDoc['email'] ?? ''; // Default to empty string if no email
      String fullName =
          userDoc['fullName'] ?? ''; // Default to empty string if no fullName

      return fullName;
    } else {
      // If the document does not exist, return null
      return "Name is not public";
    }
  } catch (e) {
    print('Error fetching user details: $e');
    return "Name is not public"; // Return null in case of error
  }
}

// Function to upload file (image or video) to Firebase Storage and save file metadata to Firestore
Future<bool> uploadFile(File file, String fileType, String postId) async {
  try {
    if (file.existsSync()) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('files/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String fileUrl = await snapshot.ref.getDownloadURL();

      DocumentReference docRef = await _firestore.collection('Files').add({
        'type': fileType,
        'url': fileUrl,
        'postId': postId,
      });

      await docRef.update({'fileId': docRef.id});

      print('File uploaded successfully: $fileUrl');
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error uploading file: $e');
    return false;
  }
}

// Example usage

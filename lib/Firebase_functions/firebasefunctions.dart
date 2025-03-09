// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/utility/resultDialoge.dart';
import 'dart:io';

import 'package:flutter/material.dart';

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

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
Future<String?> createPost(
    String userId, String postType, String caption, String text) async {
  try {
    DocumentReference docRef = await _firestore.collection('posts').add({
      'userId': userId,
      'postType': postType,
      'caption': caption,
      'text': text,
      'likeCount': 0,
      'postTime': FieldValue.serverTimestamp(),
    });

    String postId = docRef.id;

    await docRef.update({'PostId': postId});

    return postId; // Return the PostId if successful
  } catch (e) {
    print('Error creating post: $e');
    return null; // Return null if there's an error
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

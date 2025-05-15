// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitcoach/GetxController/getx.dart';
import 'package:fitcoach/api/allApi.dart';
import 'package:fitcoach/modelClass/userDetails.dart';
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

// Function to create user table (collection)
// Future<bool> createUser(
//     BuildContext context, String userId, String token, String email) async {
//   bool success = false;
//   try {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );

//     await _firestore.collection('users').doc(userId).set({
//       'userId': userId,
//       'fullName': email,
//       'email': email,
//     });
//     SharedPrefHelper.setString("userid", userId);
//     SharedPrefHelper.setString("username", email);
//     SharedPrefHelper.setString("token", email);
//     getx.userdetails.clear();
//     final userdata =
//         Userdetails(userId: userId, userimg: "", name: fullName, email: email);
//     getx.userdetails.add(userdata);
//     success = true;

//     Navigator.of(context).pop();
//   } catch (e) {
//     success = false;
//     Navigator.of(context).pop();
//     print('Error creating user: $e');
//     resultDialog(
//         context: context,
//         title: "Error",
//         buttonText: "ok",
//         icon: Icons.error,
//         message: "Something went wrong!",
//         iconBackgroundColor: AppColors.backgroundLight,
//         onButtonPressed: () {
//           Navigator.pop(context);
//         });
//   }
//   return success;
// }

// Function to create post table (collection)
Future<String?> createPost(
  String userId,
  String postType,
  String caption,
  String text,
  String username,
  File? document,
) async {
  String formattedTime =
      DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.now());
  try {
    String documenturl = "";

    if (document != null) {
      if ((postType == "video" || postType == "image") &&
          document.existsSync()) {
        // Get the download URL
        documenturl = await uploadToFirebasBucket("Community_files", document);
      }
    }

    DocumentReference docRef = await _firestore.collection('posts').add({
      'userId': userId,
      'username': username,
      'LikedId': [],
      'commentId': [],
      'postType': postType,
      'caption': caption,
      'text': text,
      'likeCount': 0,
      'postTime': formattedTime,
      'documenturl': documenturl,
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

Future<void> addLikeToComment(String commentId, String userId) async {
  try {
    // Get the reference to the post document using postId
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('comments').doc(commentId);

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

Future<void> removeLikeFromComment(String commentId, String userId) async {
  try {
    // Get the reference to the post document using postId
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('comments').doc(commentId);

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
  getx.loader.value = true;

  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('postTime', descending: true)
      .snapshots()
      .map((snapshot) {
    List<Map<String, dynamic>> allPosts =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // Filter posts by userId
    getx.userPostId.value = allPosts
        .where((post) => post['userId'] == getx.userdetails[0].userId)
        .map((post) => post['PostId'] as String)
        .toList();

    getx.loader.value = false;
    return allPosts;
  }).handleError((error) {
    print('Stream error: $error');
    getx.loader.value = false;
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

Future<String?> createComment(
    String userId, String text, String username, String postId) async {
  String formattedTime =
      DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.now());
  try {
    DocumentReference docRef = await _firestore.collection('comments').add({
      'postID': postId,
      'userId': userId,
      'username': username,
      'LikedId': [],
      'comment': text,
      'likeCount': 0,
      'postTime': formattedTime,
    });

    String commentId = docRef.id;

    await docRef.update({'commentId': commentId});
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    await postRef.update({
      'commentId': FieldValue.arrayUnion([commentId]),
    });

    return commentId; // Return the PostId if successful
  } catch (e) {
    print('Error creating Comment: $e');
    return ""; // Return null if there's an error
  }
}

Future<bool> deleteComment(String commentId, String postId) async {
  try {
    DocumentReference commentRef =
        _firestore.collection('comments').doc(commentId);

    await commentRef.delete();

    DocumentReference postRef = _firestore.collection('posts').doc(postId);

    print("");

    await postRef.update({
      'commentId': FieldValue.arrayRemove([commentId]),
    });

    return true; // Success
  } catch (e) {
    print('Error deleting comment: $e');
    return false; // Failure
  }
}

// Stream<List<Map<String, dynamic>>> fetchComments(String postId) {
//   return FirebaseFirestore.instance
//       .collection('comments')
//       .where('postID', isEqualTo: postId) // Filter by postId
//       .orderBy('postTime', descending: false)
//       .snapshots()
//       .map((snapshot) {
//     List<Map<String, dynamic>> allPosts =
//         snapshot.docs.map((doc) => doc.data()).toList();

//     // Filter posts by userId (if needed)
//     getx.userCommentId.value = allPosts
//         .where((post) => post['userId'] == getx.userdetails[0].userId)
//         .map((post) => post['commentId'] as String)
//         .toList();

//     print(allPosts);

//     return allPosts;
//   }).handleError((error) {
//     print('Stream error: $error');
//   });
// }

Stream<List<Map<String, dynamic>>> streamCommentsByPostId(String postId) {
  return _firestore
      .collection('comments')
      .where('postID', isEqualTo: postId)
      // .orderBy('postTime', descending: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return {
        'commentId': doc.id,
        "postID": doc['postID'],
        'userId': doc['userId'],
        'username': doc['username'],
        'comment': doc['comment'],
        'likeCount': doc['likeCount'],
        'LikedId': List<String>.from(doc['LikedId']),
        'postTime': doc['postTime'],
      };
    }).toList();
  });
}

Future<void> deleteCollection(String collectionName,
    {int batchSize = 100}) async {
  final collectionRef = FirebaseFirestore.instance.collection(collectionName);
  final querySnapshot = await collectionRef.limit(batchSize).get();

  final batch = FirebaseFirestore.instance.batch();
  for (var doc in querySnapshot.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit();

  // If there are still documents, recursively call the function
  if (querySnapshot.docs.length >= batchSize) {
    await deleteCollection(collectionName, batchSize: batchSize);
  }
}

Future<String> uploadToFirebasBucket(String folderpath, File? file) async {
  try {
    if (file != null && file.existsSync()) {
      final storage = FirebaseStorage.instanceFor(
        bucket:
            'gs://fitcoach-89ccb.firebasestorage.app', // Fixed the typo in bucket URL
      );

      // Generate file name
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      // Define the path inside the bucket
      final storageRef = storage.ref().child('$folderpath/$fileName');

      // Upload the file
      final uploadTask = await storageRef.putFile(file);

      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } else {
      print('⚠️ No file provided or file does not exist.');

      return "";
    }
  } catch (e) {
    print('❌ Error uploading: $e');
    return "";
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> deletePost(String postId, BuildContext context) async {
  try {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    if (postId != "") {
      // Get the document reference
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      DocumentSnapshot postSnapshot = await postRef.get();

      if (!postSnapshot.exists) {
        print("❌ Post not found.");
        return false;
      }

      // Get the document URL from the post
      String? documentUrl = postSnapshot.get('documenturl');

      // Delete file from Firebase Storage if documentUrl is not empty
      if (documentUrl != null && documentUrl.isNotEmpty) {
        try {
          final storage = FirebaseStorage.instanceFor(
            bucket: 'gs://fitcoach-89ccb.firebasestorage.app',
          );

          // Extract the file path from the URL
          final ref = storage.refFromURL(documentUrl);
          await ref.delete();
          print("✅ File deleted from Firebase Storage.");
        } catch (e) {
          print("⚠️ Error deleting file from storage: $e");
          // Continue to delete the post even if file deletion fails
        }
      }

      // Delete the Firestore document
      await postRef.delete();
      print("✅ Post deleted from Firestore.");
      Get.back();
      return true;
    } else {
      Get.back();

      return false;
    }
  } catch (e) {
    print('❌ Error deleting post: $e');
    Get.back();

    return false;
  }
}

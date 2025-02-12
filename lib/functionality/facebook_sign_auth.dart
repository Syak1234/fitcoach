import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceFacebook {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// **Handle Facebook Sign-In or Linking**
  Future<Map<String, dynamic>?> handleFacebookSignIn(
      BuildContext context) async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        // If no user is logged in, attempt Facebook sign-in
        UserCredential? userCredential = await signInWithFacebook(context);
        if (userCredential != null) {
          // Fetch user details after successful sign-in
          return await getFacebookUserData();
        }
      } else {
        // If user is already logged in, check for linked providers
        bool isFacebookLinked = _isProviderLinked(currentUser, 'facebook.com');

        if (isFacebookLinked) {
          // If Facebook is linked, fetch user details
          return await getFacebookUserData();
        } else {
          // Attempt to link Facebook account
          final LoginResult result = await FacebookAuth.instance.login();

          if (result.status == LoginStatus.success) {
            final OAuthCredential facebookAuthCredential =
                FacebookAuthProvider.credential(
                    result.accessToken!.tokenString);

            // Link the Facebook account
            await currentUser.linkWithCredential(facebookAuthCredential);
            print("Facebook account linked successfully!");

            // Fetch user details after successful linking
            return await getFacebookUserData();
          } else {
            print("Facebook linking failed: ${result.message}");
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        // Handle case where Facebook account is already linked to another account
        _showErrorDialog(context,
            "This Facebook account is already linked to another user.");
      } else {
        print("Firebase Auth Error: ${e.message}");
      }
    } catch (e) {
      print("Error in handleFacebookSignIn: ${e.toString()}");
    }

    return null;
  }

  /// **Facebook Sign-In Handling**
  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        // Try signing in with Facebook
        return await _auth.signInWithCredential(facebookAuthCredential);
      } else {
        print("Facebook sign-in failed: ${result.message}");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        String email = e.email ?? "";

        if (email.isNotEmpty) {
          List<String> providers =
              await _auth.fetchSignInMethodsForEmail(email);

          if (providers.isNotEmpty) {
            String existingProvider = providers.first;
            print("Account exists with $existingProvider. Signing in...");

            if (existingProvider == "google.com") {
              await _signInWithGoogleAndLink(e.credential!);
            } else {
              _showErrorDialog(context,
                  "Please sign in with $existingProvider first, then link Facebook.");
            }
          } else {
            _showErrorDialog(context,
                "Your email is already registered, but we couldn't detect a provider. Try signing in manually.");
          }
        }
      } else {
        print("Firebase Auth Error: ${e.message}");
      }
    }
    return null;
  }

  /// **Google Sign-In & Link Facebook**
  Future<void> _signInWithGoogleAndLink(
      AuthCredential facebookCredential) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Google
      UserCredential userCredential =
          await _auth.signInWithCredential(googleCredential);

      // Link Facebook credential
      await userCredential.user?.linkWithCredential(facebookCredential);
      print("Facebook account linked successfully!");
    } catch (e) {
      print("Error linking Facebook account: ${e.toString()}");
    }
  }

  /// **Check if Provider is Linked**
  bool _isProviderLinked(User user, String providerId) {
    return user.providerData
        .any((provider) => provider.providerId == providerId);
  }

  /// **Fetch Facebook User Details**
  Future<Map<String, dynamic>?> getFacebookUserData() async {
    try {
      final userData = await FacebookAuth.instance
          .getUserData(fields: "email,name,picture.width(200)");
      log("Facebook User Data: $userData");
      return userData;
    } catch (e) {
      log("Error fetching Facebook user data: $e");
      return null;
    }
  }

  /// **Logout/Sign-Out**
  Future<void> signOut(BuildContext context) async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Facebook
      await FacebookAuth.instance.logOut();

      // Sign out from Google if necessary
      await GoogleSignIn().signOut();

      // Show a message or navigate back to the login screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have been signed out successfully.")),
      );
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e")),
      );
    }
  }

  /// **Helper Function to Show Error Dialog**
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sign-In Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      print('email' + googleSignInAccount!.email.toString());
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        UserCredential result =
            await _auth.signInWithCredential(authCredential);
        User? user = result.user;

        log(user!.metadata.toString());
        log(user.displayName.toString());
        log(user.phoneNumber.toString());
        log(user.photoURL.toString());
// log(user!.phoneNumber.toString());
        if (result != null) {
          signOut();

          return user;
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => HomePage()));
        } // if result not null we simply call the MaterialpageRoute,
        // for go to the HomePage screen
      }
    } catch (e) {
      log("Google Sign-In Error: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

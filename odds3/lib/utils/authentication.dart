import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:odds3/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../classes/bets_provider.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
      );
    }

    return firebaseApp;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    final userState = Provider.of<CurUserProvider>(context, listen: false);
    final betsState = Provider.of<BetsProvider>(context, listen: false);

    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await userState.auth.signInWithCredential(credential);

        user = userCredential.user;
        if (user != null && await isNewUser(user: user)) {
          await addUser(user: user);
        }
        userState.fetchCurUser();
        betsState.fetchBets();
        betsState.fetchFriendBets();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
                  'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final userState = Provider.of<CurUserProvider>(context, listen: false);
    final betsState = Provider.of<BetsProvider>(context, listen: false);

    try {
      await googleSignIn.signOut();
      await userState.auth.signOut();
      betsState.resetBets();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<void> addUser({required User user}) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Name, email address, and profile photo URL from gmail
    final name = user.providerData.first.displayName;
    final email = user.providerData.first.email;
    final profilePhoto = user.providerData.first.photoURL;
    final dateJoined = Timestamp.now().millisecondsSinceEpoch;

    // Create friends, bets, and friendInvites subcollections and set them as blank

    // IMPORTANT: creating subcollections implicitly creates a new empty document for that
    // subcollection. Therefore, any time we need to count documents (to see how many friends)
    // someone has, we must do n - 1.
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .add({});
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bets')
        .add({});
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('friendInvites')
        .add({});

    return users.doc(user.uid).set({
      "userId": user.uid,
      "fullName": name, // John Doe
      "email": email, // email
      "username": email?.substring(0, email.indexOf('@')),
      "photoURL": profilePhoto,
      "dateJoined": dateJoined,
      "betsWon": 0,
      "betsLost": 0,
      "tokens": 0,
      "lastActive": dateJoined,
    }).catchError((error) => print("Failed to add user: $error"));
  }

  static Future<bool> isNewUser({required User user}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user
    var doc = await users.doc(user.uid).get();
    return !doc.exists;
  }
}

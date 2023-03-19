import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odds3/classes/user.dart';

class CurUserProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;
  CurUser? _curUser;

  CurUserProvider() {
    auth.authStateChanges().listen((user) {
      _user = user;
      if (_user == null) {
        _curUser = null;
      } else {
        fetchCurUser();
      }
      notifyListeners();
    });
  }
  bool get isAuthenticated => _user != null;
  User? get user => _user;
  CurUser? get curUser => _curUser;

  Future<void> fetchCurUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _curUser = CurUser.fromFirestore(documentSnapshot);
        notifyListeners();
      } else {
        print('User does not exist on the database');
      }
    });
  }
}

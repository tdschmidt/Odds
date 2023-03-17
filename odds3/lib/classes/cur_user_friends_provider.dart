import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odds3/classes/user.dart';

class UserFriendsProvider with ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  List<CurUser> _userFriends = [];
  List<CurUser> get userFriends => _userFriends;

  void resetUserFriends() {
    _userFriends = [];
  }

  Future<void> fetchFriends() async {
    List<CurUser> friends = [];
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    friends.add(CurUser.fromFirestore(snapshot));

    QuerySnapshot snapshotF = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friends')
        .where('id', isNotEqualTo: '')
        .get();

    List<String> ids = snapshotF.docs.map((doc) => doc.id).toList();

    for (String id in ids) {
      DocumentSnapshot userSnapShot =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      CurUser toAdd = CurUser.fromFirestore(userSnapShot);

      friends.add(toAdd);
    }
    _userFriends = friends;
    notifyListeners();
  }
}

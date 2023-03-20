import 'package:cloud_firestore/cloud_firestore.dart';

class CurUser {
  String fullName;
  int betsWon;
  int betsLost;
  String username;
  int tokens;
  String uid;
  String? photoURL;

  CurUser(
      {required this.fullName,
      required this.tokens,
      required this.betsWon,
      required this.betsLost,
      required this.username,
      required this.uid,
      required this.photoURL});

  factory CurUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    data.removeWhere(
        (key, value) => value == '' || value == null || data.isEmpty);
    return CurUser(
      uid: data['id'] ?? '',
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
      betsWon: data['betsWon'] ?? 0,
      betsLost: data['betsLost'] ?? 0,
      tokens: data['tokens'] ?? 0,
      photoURL: data['photoURL'] ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': uid,
      'fullName': fullName,
      'username': username,
      'betsWon': betsWon,
      'betsLost': betsLost,
      'tokens': tokens,
      'photoURL': photoURL,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odds3/classes/bet_feed_item.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:odds3/classes/user.dart';
import 'package:provider/provider.dart';

class FriendRequestProvider with ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  List<FriendRequest> _friend_requests = [];
  List<FriendRequest> get friend_request => _friend_requests;

  void resetFriendRequests() {
    _friend_requests = [];
  }

  Future<void> fetchFriendRequest(String id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friendInvites')
        .where('id', isNotEqualTo: '') //needed?
        .where('id', isEqualTo: id)
        .get();
    var friends_data = snapshot.docs.first.data();
    _friend_requests =
        snapshot.docs.map((doc) => FriendRequest.fromFirestore(doc)).toList();

    notifyListeners();
  }

  Future<void> acceptRequest(Bet bet) async {
    bet.status = 1;
    // update receiver (who is accepting)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());
    // update bettor
    await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.bettorId)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());
    notifyListeners();
  }

  Future<void> rejectRequest(Bet bet) async {
    bet.status = 3;
    // update receiver (who is rejecting)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());

    // update bettor
    await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.bettorId)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());
    notifyListeners();
  }
}

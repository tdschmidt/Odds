import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odds3/classes/friend_request_item.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:odds3/classes/user.dart';
import 'package:provider/provider.dart';

class FriendRequestProvider with ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  List<FriendRequest> _friend_requests = [];
  List<FriendRequest> get friend_requests => _friend_requests;

  void resetFriendRequests() {
    _friend_requests = [];
  }

  Future<void> fetchFriendRequest() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friendInvites')
        .where('id', isNotEqualTo: '')
        .get();
    _friend_requests =
        snapshot.docs.map((doc) => FriendRequest.fromFirestore(doc)).toList();
    notifyListeners();
    print(_friend_requests);
  }

  Future<void> makeFriendRequest(FriendRequest friendRequest) async {
    // update inviter (who invites friend)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .set(friendRequest.toFirestore());

    // update receiver
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendRequest.receiverId)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .set(friendRequest.toFirestore());
    notifyListeners();
    fetchFriendRequest();
  }

  Future<void> acceptFriendRequest(FriendRequest friendRequest) async {
    friendRequest.status = 1;
    // update receiver (who is accepting)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .update(friendRequest.toFirestore());
    // update inviter
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendRequest.inviterId)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .update(friendRequest.toFirestore());
    notifyListeners();
  }

  Future<void> rejectFriendRequest(FriendRequest friendRequest) async {
    friendRequest.status = 3;
    // update receiver (who is rejecting)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .update(friendRequest.toFirestore());

    // update inviter
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendRequest.inviterId)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .update(friendRequest.toFirestore());
    notifyListeners();
  }
}

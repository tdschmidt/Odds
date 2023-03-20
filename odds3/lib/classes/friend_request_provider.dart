import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odds3/classes/friend_request_item.dart';

class FriendRequestProvider with ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  List<FriendRequest> _friend_requests = [];
  List<FriendRequest> get friend_requests => _friend_requests;

  void resetFriendRequests() {
    _friend_requests = [];
  }

  Future<void> fetchFriendRequests() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friendInvites')
        .where('id', isNotEqualTo: '')
        .get();
    _friend_requests =
        snapshot.docs.map((doc) => FriendRequest.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> makeFriendRequest(FriendRequest friendRequest) async {
    // update inviter (who invites friend)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .set(friendRequest.toFirestore())
        .onError((e, _) =>
            print("Error making friend request for user ${user?.uid}: $e"));

    // update receiver
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendRequest.receiverId)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .set(friendRequest.toFirestore())
        .onError((e, _) => print(
            "Error making friend request for user ${friendRequest.receiverId}: $e"));
    notifyListeners();
    fetchFriendRequests();
  }

  Future<void> acceptFriendRequest(FriendRequest friendRequest) async {
    friendRequest.status = 1;
    // update receiver (who is accepting)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .update(friendRequest.toFirestore())
        .onError((e, _) => print(
            "Error accepting friend request ${friendRequest.id} for user ${user?.uid}: $e"));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendRequest.receiverId)
        .collection('friends')
        .doc(friendRequest.inviterId)
        .set({'id': friendRequest.inviterId}).onError((e, _) => print(
            "Error adding friend ${friendRequest.inviterId} for user ${friendRequest.receiverId}: $e"));

    // update inviter
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendRequest.inviterId)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .update(friendRequest.toFirestore())
        .onError((e, _) => print(
            "Error accepting friend request ${friendRequest.id} for user ${friendRequest.inviterId}: $e"));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendRequest.inviterId)
        .collection('friends')
        .doc(friendRequest.receiverId)
        .set({'id': friendRequest.receiverId}).onError((e, _) => print(
            "Error adding friend ${friendRequest.receiverId} for user ${friendRequest.inviterId}: $e"));

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
        .update(friendRequest.toFirestore())
        .onError((e, _) => print(
            "Error rejecting friend request ${friendRequest.id} for user ${user?.uid}: $e"));

    // update inviter
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendRequest.inviterId)
        .collection('friendInvites')
        .doc(friendRequest.id)
        .update(friendRequest.toFirestore())
        .onError((e, _) => print(
            "Error rejecting friend request ${friendRequest.id} for user ${friendRequest.inviterId}: $e"));
    notifyListeners();
  }
}

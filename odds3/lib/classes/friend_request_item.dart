import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  // May eventually need to implement receiverId and bettorId if we do not retrieve info by username
  String id;
  String inviterId;
  String inviterName;
  String receiverId;
  String receiverName;
  int timestampCreated;
  int status;

  FriendRequest(
      {required this.id,
      required this.inviterId,
      required this.inviterName,
      required this.receiverId,
      required this.receiverName,
      required this.timestampCreated,
      required this.status});

  void acceptFriendRequest() {
    status = 1;
  }

  void rejectFriendRequest() {
    status = 3;
  }

  factory FriendRequest.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    data.removeWhere(
        (key, value) => value == '' || value == null || data.isEmpty);
    return FriendRequest(
        id: data['id'] ?? '',
        inviterId: data['inviterId'] ?? '',
        inviterName: data['inviterName'] ?? '',
        receiverId: data['receiverId'] ?? '',
        receiverName: data['receiverName'] ?? '',
        timestampCreated: data['timestampCreated'] ?? 000000000000,
        status: data['status'] ?? 2);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'inviterId': inviterId,
      'inviterName': inviterName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'timestampCreated': timestampCreated,
      'status': status,
    };
  }
}

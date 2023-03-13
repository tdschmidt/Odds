import 'package:cloud_firestore/cloud_firestore.dart';

class Bet {
  // May eventually need to implement receiverId and bettorId if we do not retrieve info by username
  String id;
  String bettorId;
  String receiverId;
  int bettorAmount = 0;
  int receiverAmount = 0;
  String bettorProfileUrl;
  String receiverProfileUrl;
  String betText;
  bool userLiked = false;
  int timestampCreated;
  int status = 0;
  bool? winner;

  String bettorName;
  String receiverName;

  Bet(
      {required this.id,
      required this.bettorId,
      required this.receiverId,
      required this.bettorAmount,
      required this.receiverAmount,
      required this.bettorProfileUrl,
      required this.receiverProfileUrl,
      required this.betText,
      required this.status,
      required this.timestampCreated,
      this.userLiked = false,
      this.winner,
      required this.bettorName,
      required this.receiverName});

  void acceptBet() {
    status = 1;
  }

  void rejectBet() {
    status = 3;
  }

  void concedeBet(String concederUid) {
    winner = concederUid == bettorId;
    status = 2;
  }

  factory Bet.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    data.removeWhere(
        (key, value) => value == '' || value == null || data.isEmpty);
    return Bet(
        id: data['id'] ?? '',
        bettorId: data['bettorId'] ?? '',
        receiverId: data['receiverId'] ?? '',
        bettorAmount: data['bettorAmount'] ?? 0,
        receiverAmount: data['receiverAmount'] ?? 0,
        bettorProfileUrl: data['bettorProfileUrl'] ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
        receiverProfileUrl: data['receiverProfileUrl'] ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
        betText: data['betText'] ?? '',
        timestampCreated: data['timestampCreated'] ?? 8640000000000,
        userLiked: data['userLiked'] ?? false,
        status: data['status'] ?? 0,
        winner: data['winner'],
        bettorName: data['bettorName'] ?? '',
        receiverName: data['receiverName'] ?? '');
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'bettorId': bettorId,
      'receiverId': receiverId,
      'bettorAmount': bettorAmount,
      'receiverAmount': receiverAmount,
      'bettorProfileUrl': bettorProfileUrl,
      'receiverProfileUrl': receiverProfileUrl,
      'betText': betText,
      'timestampCreated': timestampCreated,
      'userLiked': userLiked,
      'status': status,
      'winner': winner,
      'bettorName': bettorName,
      'receiverName': receiverName
    };
  }
}

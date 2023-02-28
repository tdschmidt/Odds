import 'package:cloud_firestore/cloud_firestore.dart';

class Bet {
  // May eventually need to implement receiverId and bettorId if we do not retrieve info by username
  String id;
  String bettor;
  String receiver;
  int bettorAmount = 0;
  int receiverAmount = 0;
  String betText;
  bool userLiked = false;
  int timestampCreated;
  int status = 0;
  bool? winner;

  Bet(
      {required this.id,
      required this.bettor,
      required this.receiver,
      required this.bettorAmount,
      required this.receiverAmount,
      required this.betText,
      required this.status,
      required this.timestampCreated,
      this.userLiked = false,
      this.winner});

  void acceptBet() {
    status = 1;
  }

  void rejectBet() {
    status = 3;
  }

  void concedeBet(String concederUid) {
    winner = concederUid == bettor;
    status = 2;
  }

  factory Bet.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    data.removeWhere((key, value) => value == '' || value == null || data.isEmpty);
    return Bet(
      id: data['id'] ?? '',
      bettor: data['bettor'] ?? '',
      receiver: data['receiver'] ?? '',
      bettorAmount: data['bettorAmount'] ?? 0,
      receiverAmount: data['receiverAmount'] ?? 0,
      betText: data['betText'] ?? '',
      timestampCreated: data['timestampCreated'] ?? 0,
      userLiked: data['userLiked'] ?? false,
      status: data['status'] ?? 0,
      winner: data['winner'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'bettor': bettor,
      'receiver': receiver,
      'bettorAmount': bettorAmount,
      'receiverAmount': receiverAmount,
      'betText': betText,
      'timestampCreated': timestampCreated,
      'userLiked': userLiked,
      'status': status,
      'winner': winner,
    };
  }
}

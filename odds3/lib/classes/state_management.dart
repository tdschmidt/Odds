import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odds3/classes/bet_feed_item.dart';

import '../dummy_data.dart';

class StateManagement with ChangeNotifier {
  List<Bet> _bets = [];

  User? user = FirebaseAuth.instance.currentUser;

  List<Bet> get bets => _bets;

  Future<void> fetchBets() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('bets')
          .where('id', isNotEqualTo: '')
          .get();
    _bets = snapshot.docs.map((doc) => Bet.fromFirestore(doc)).toList();
    notifyListeners();
  }

  /*
  void fetchBets() {
    _bets = dummy_bets;
    notifyListeners();
  }

  void acceptBet(Bet bet) {
    bet.status = 1;
    notifyListeners();
  }

  void rejectBet(Bet bet) {
    bet.status = 3;
    notifyListeners();
  }

  void concedeBet(Bet bet, String concederUid) {
    bet.winner = concederUid == bet.bettor;
    bet.status = 2;
    notifyListeners();
  }  
  */
  
  void makeBet(Bet bet) {
    _bets.add(bet);
    notifyListeners();
  }
  
  Future<void> acceptBet(Bet bet) async {
    bet.status = 1;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());
    notifyListeners();
  }

  Future<void> rejectBet(Bet bet, bool completed) async {
    bet.status = 3;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());
    notifyListeners();
  }

  Future<void> concedeBet(Bet bet) async {
    bet.status = 2;
    //bet.winner = uid == bettor;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());
    notifyListeners();
  }
}

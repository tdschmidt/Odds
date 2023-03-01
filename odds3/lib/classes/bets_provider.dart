import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odds3/classes/bet_feed_item.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:odds3/classes/user.dart';
import 'package:provider/provider.dart';

class BetsProvider with ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  List<Bet> _bets = [];
  List<Bet> get bets => _bets;

  List<Bet> _friendBets = [];
  List<Bet> get friendBets => _friendBets;

  void resetBets() {
    _bets = [];
    _friendBets = [];
  }

  Future<void> fetchBets() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('bets')
        .where('id', isNotEqualTo: '')
        .get();
    _bets = snapshot.docs.map((doc) => Bet.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> fetchFriendBets() async {
    List<Bet> all_bets = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    final List<QueryDocumentSnapshot> users = querySnapshot.docs;

    for (final QueryDocumentSnapshot user in users) {
      QuerySnapshot userBets = await user.reference.collection('bets').get();
      List<Bet> cur_bets =
          userBets.docs.map((doc) => Bet.fromFirestore(doc)).toList();

      all_bets.addAll(cur_bets);
    }

    _friendBets = all_bets;

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
  
  void makeBet(Bet bet) {
    _bets.add(bet);
    notifyListeners();
  }
  */

  Future<void> makeBet(Bet bet) async {
    // update bettor (who makes the bet)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('bets')
        .doc(bet.id)
        .set(bet.toFirestore());

    // update receiver
    await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.receiverId)
        .collection('bets')
        .doc(bet.id)
        .set(bet.toFirestore());
    notifyListeners();
    fetchBets();
  }

  Future<void> acceptBet(Bet bet) async {
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

  Future<void> rejectBet(Bet bet) async {
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

  Future<void> concedeBet(Bet bet) async {
    bet.status = 2;
    // winner = 0 for better winning, 1 for receiver winning
    bet.winner = user?.uid == bet.bettorId;

    //updates both the bettor and the receiver's obj
    await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.bettorId)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.receiverId)
        .collection('bets')
        .doc(bet.id)
        .update(bet.toFirestore());
    notifyListeners();
  }
}

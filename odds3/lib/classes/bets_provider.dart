import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odds3/classes/bet_feed_item.dart';
import 'package:odds3/classes/user.dart';

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
    Set<Bet> allBets = {};
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    final List<QueryDocumentSnapshot> users = querySnapshot.docs;

    for (final QueryDocumentSnapshot user in users) {
      QuerySnapshot userBets = await user.reference
          .collection('bets')
          .where('id', isNotEqualTo: '')
          .get();
      List<Bet> curBets =
          userBets.docs.map((doc) => Bet.fromFirestore(doc)).toList();

      allBets.addAll(curBets);
    }

    //get user friends
    List<CurUser> friends = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        friends.add(CurUser.fromFirestore(documentSnapshot));
      } else {
        print('User as a friend does not exist on the database');
      }
    });

    QuerySnapshot snapshotF = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('friends')
        .where('id', isNotEqualTo: '')
        .get();

    List<String> ids = snapshotF.docs.map((doc) => doc.id).toList();
    print(ids);
    for (Bet bet in allBets.toList()) {
      if (!ids.contains(bet.bettorId) && !ids.contains(bet.receiverId)) {
        allBets.remove(bet);
      }
    }

    _friendBets = allBets.toList();
    notifyListeners();
  }

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
    bool winner = user?.uid == bet.bettorId;
    bet.winner = winner;

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

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.bettorId)
        .get();

    CurUser bettor = CurUser.fromFirestore(snapshot);

    DocumentSnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.receiverId)
        .get();

    CurUser receiver = CurUser.fromFirestore(snapshot2);

    int receiverBetsWon = 0;
    int bettorBetsWon = 0;
    int receiverBetsLost = 0;
    int bettorBetsLost = 0;
    int receiverTokens = 0;
    int bettorTokens = 0;

    if (winner) {
      receiverBetsWon = 1;
      bettorBetsLost = 1;

      receiverTokens = bet.bettorAmount;
      bettorTokens = -bet.bettorAmount;
    } else {
      receiverBetsLost = 1;
      bettorBetsWon = 1;

      receiverTokens = -bet.receiverAmount;
      bettorTokens = bet.receiverAmount;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.bettorId)
        .update({
      "tokens": FieldValue.increment(bettorTokens),
      "betsWon": FieldValue.increment(bettorBetsWon),
      "betsLost": FieldValue.increment(bettorBetsLost)
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(bet.receiverId)
        .update({
      "tokens": FieldValue.increment(receiverTokens),
      "betsWon": FieldValue.increment(receiverBetsWon),
      "betsLost": FieldValue.increment(receiverBetsLost)
    });
  }
}

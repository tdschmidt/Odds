import 'package:flutter/material.dart';
import 'package:odds3/classes/bet_feed_item.dart';
import 'package:odds3/classes/bets_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class BetPage extends StatefulWidget {
  const BetPage({super.key});

  @override
  State<BetPage> createState() => _BetPageState();
}

class _BetPageState extends State<BetPage> {
  TextEditingController _friendController = TextEditingController();
  TextEditingController _yourRiskController = TextEditingController();
  TextEditingController _theirRiskController = TextEditingController();
  TextEditingController _betTextController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  void click(BetsProvider state) async {
    String friend = _friendController.text;
    String yourBet = _yourRiskController.text;
    String theirBet = _theirRiskController.text;
    String betText = _betTextController.text;
    var querySnapShotUser = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get();
    var bettor = querySnapShotUser.data();

    var querySnapShotFriend = await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: friend)
        .get();
    var receiver = querySnapShotFriend.docs.first.data();

    int currentTimestamp = Timestamp.now().millisecondsSinceEpoch;

    // creating the bet ids using sha1
    String idStringInput = receiver['userId'] +
        bettor?['userId'] +
        betText +
        currentTimestamp.toString();
    List<int> plaintextBytes =
        utf8.encode(idStringInput); // Convert the string to a list of bytes
    Digest sha1BetHash = sha1.convert(plaintextBytes);
    String betId = sha1BetHash.toString();

    var numCheck1 = num.tryParse(yourBet);
    var numCheck2 = num.tryParse(theirBet);

    if (numCheck1 != null && numCheck2 != null) {
      Bet newBet = Bet(
        id: betId,
        bettorId: bettor?['userId'],
        receiverId: receiver['userId'],
        bettorAmount: int.parse(yourBet),
        receiverAmount: int.parse(theirBet),
        bettorProfileUrl: bettor?['photoURL'],
        receiverProfileUrl: receiver['photoURL'],
        timestampCreated: currentTimestamp,
        betText: betText,
        status: 0,
        bettorName: bettor?['username'],
        receiverName: receiver['username'],
      );

      bool isReceiverAFriend = await state.isFriend(newBet);
      if (!isReceiverAFriend) {
        final snackBar = SnackBar(
          content: const Text(
              'You cannot make a bet against someone who is not your friend.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        state.makeBet(newBet);
        final snackBar = SnackBar(
          content: Text(
              'You bet ${newBet.receiverName} ${newBet.bettorAmount} to win ${newBet.receiverAmount}! Goodluck :)'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        content: const Text(
            'Both your risk and your opponent\'s risk must be a number.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    _friendController.clear();
    _yourRiskController.clear();
    _theirRiskController.clear();
    _betTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BetsProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Place a Bet',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: _friendController,
                decoration: InputDecoration(
                  labelText: 'Opponent\'s username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _yourRiskController,
                decoration: InputDecoration(
                  labelText: 'Your risk (i.e. 4)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _theirRiskController,
                decoration: InputDecoration(
                  labelText: 'Your opponent\'s risk (i.e. 4)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Container(
                height: 120.0,
                child: TextFormField(
                  controller: _betTextController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'What is your wager?',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => click(state),
                  child: Text(
                    'Place Bet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:odds3/classes/bet_feed_item.dart';
import 'package:odds3/classes/bets_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

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
  TextEditingController _songTitleController = TextEditingController();
  TextEditingController _streamNumberController = TextEditingController();
  TextEditingController _dateinput = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  void click(BetsProvider state) async {
    String friend = _friendController.text;
    String yourBet = _yourRiskController.text;
    String theirBet = _theirRiskController.text;
    String betText = _betTextController.text;
    String songTitle = _songTitleController.text;
    String date = _dateinput.text;
    String streamNumber = _streamNumberController.text;
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
        betText:
            songTitle + ' will reach ' + streamNumber + ' streams by ' + date,
        status: 0,
        bettorName: bettor?['username'],
        receiverName: receiver['username'],
        songTitle: songTitle,
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
    _songTitleController.clear();
    _streamNumberController.clear();
    _dateinput.clear();
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
              SizedBox(height: 16.0),
              Container(
                height: 70.0,
                child: TextFormField(
                  controller: _songTitleController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'What song would you like to wager on?',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 70.0,
                child: TextFormField(
                  controller: _streamNumberController, // change this
                  maxLines: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'How many streams will it get?',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 70.0,
                child: TextFormField(
                  controller: _dateinput,
                  keyboardType:
                      TextInputType.datetime, //is this right or necessary
                  maxLines: 4,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      //print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        _dateinput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'By what date?',
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odds3/classes/bets_provider.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:provider/provider.dart';
import '../classes/bet_feed_item.dart';

class MeFeedList extends StatefulWidget {
  List<Bet> listItems;
  final status;
  MeFeedList(this.listItems, this.status);

  @override
  State<MeFeedList> createState() => _MeFeedListState();
}

class _MeFeedListState extends State<MeFeedList> {
  User? user = FirebaseAuth.instance.currentUser;

  void filterList(List<Bet> bets) {
    bets.sort((a, b) => b.timestampCreated.compareTo(a.timestampCreated));

    if (widget.status == 1) {
      widget.listItems =
          bets.where((item) => item.status == 0 || item.status == 1).toList();
    } else if (widget.status == 2) {
      widget.listItems = bets.where((item) => item.status == 2).toList();
    }
  }

  Widget getBetColumn(BetsProvider state, Bet bet, CurUserProvider userState) {
    var coinIcon = Image.network(
      'https://img.icons8.com/external-vectorslab-flat-vectorslab/512/external-Casino-Token-casino-vectorslab-flat-vectorslab.png',
      width: 20,
      height: 20,
    );
    if (bet.status == 0) {
      return user?.uid == bet.receiverId
          ? Row(children: [
              Text('Accept Bet: '),
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  state.acceptBet(bet);
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  state.rejectBet(bet);
                },
              ),
            ])
          : const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "You Proposed",
                style: TextStyle(
                    color: Color.fromARGB(255, 184, 74,
                        43)), //Should be replaced with theme color
              ),
            );
    } else if (bet.status == 1) {
      //both should have conceding option
      return Row(children: [
        Text('Concede Bet: '),
        IconButton(
          icon: Icon(Icons.close, color: Colors.red),
          onPressed: () async {
            //have to change this to whoever is signed in
            await state.concedeBet(bet);
            userState.fetchCurUser();
          },
        ),
      ]);
    } else if (bet.status == 2) {
      Text text;
      if (user?.uid == bet.receiverId) {
        text = (bet.winner == true)
            ? Text('You Won ${bet.bettorAmount}',
                style: TextStyle(color: Colors.green))
            : Text('You Lost ${bet.receiverAmount}',
                style: TextStyle(color: Colors.red));
      } else {
        text = (bet.winner == false)
            ? Text('You Won ${bet.receiverAmount}',
                style: TextStyle(color: Colors.green))
            : Text('You Lost ${bet.bettorAmount}',
                style: TextStyle(color: Colors.red));
      }
      return Row(children: [
        text,
        IconButton(
          icon: coinIcon,
          onPressed: null,
        )
      ]);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final betsState = Provider.of<BetsProvider>(context);
    final userState = Provider.of<CurUserProvider>(context);
    filterList(betsState.bets);

    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var bet = widget.listItems[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            color: Theme.of(context).colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: user?.uid == bet.bettorId
                          ? Text("You bet ${bet.receiverName}")
                          : Text("${bet.bettorName} bets You"),
                      subtitle: Padding(
                        padding: EdgeInsets.only(
                            top: 8.0), // Add top padding to the subtitle
                        child: Text(bet.betText),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(bet.bettorAmount.toString()),
                      Text("to win"),
                      Text(bet.receiverAmount.toString()),
                      SizedBox(height: 2.0),
                      getBetColumn(betsState, bet, userState),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

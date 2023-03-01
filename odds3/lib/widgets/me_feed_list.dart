import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odds3/classes/state_management.dart';
import 'package:odds3/dummy_data.dart';
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
    if (widget.status == 1) {
      widget.listItems =
          bets.where((item) => item.status == 0 || item.status == 1).toList();
    } else if (widget.status == 2) {
      widget.listItems = bets.where((item) => item.status == 2).toList();
    }
  }

  Widget getBetColumn(StateManagement state, Bet bet) {
    var coinIcon = Image.network(
      'https://img.icons8.com/external-vectorslab-flat-vectorslab/512/external-Casino-Token-casino-vectorslab-flat-vectorslab.png',
      width: 20,
      height: 20,
    );
    if (bet.status == 0) {
      return user?.uid == bet.receiver
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
                  state.rejectBet(bet, true);
                },
              ),
            ])
          : const Text(
              "You Proposed",
              style: TextStyle(color: Colors.blue),
            );
    } else if (bet.status == 1) {
      //both should have conceding option
      return Row(children: [
        Text('Concede Bet: '),
        IconButton(
          icon: Icon(Icons.close, color: Colors.red),
          onPressed: () {
            //have to change this to whoever is signed in
            state.concedeBet(bet);
          },
        ),
      ]);
    } else if (bet.status == 2) {
      Icon icon;
      Text text;
      if (user?.uid == bet.receiver) {
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
          onPressed: () {},
        )
      ]);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<StateManagement>(context);
    filterList(state.bets);

    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var bet = widget.listItems[index];
        return Card(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: user?.uid == bet.bettor
                    ? Text("You bet ${bet.receiverName}")
                    : Text("${bet.bettorName} bets You"),
                subtitle: Text(bet.betText),
              )),
              Column(
                children: <Widget>[
                  Text(bet.bettorAmount.toString()),
                  Text("to win"),
                  Text(bet.receiverAmount.toString()),
                  getBetColumn(state, bet),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:odds3/classes/state_management.dart';
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
  void filterList(List<Bet> bets) {
    if (widget.status == 1) {
      widget.listItems =
          bets.where((item) => item.status == 0 || item.status == 1).toList();
    } else if (widget.status == 2) {
      widget.listItems = bets.where((item) => item.status == 2).toList();
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
                title: Text(bet.bettor + ' bets you'),
                subtitle: Text(bet.betText),
              )),
              Column(
                children: <Widget>[
                  Text(bet.bettorAmount.toString()),
                  Text("to win"),
                  Text(bet.receiverAmount.toString()),
                  bet.status == 0
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
                      : Container(),
                  bet.status == 1
                      ? Row(children: [
                          Text('Concede Bet: '),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              //have to change this to whoever is signed in
                              state.concedeBet(bet, bet.bettor);
                            },
                          ),
                        ])
                      : Container(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

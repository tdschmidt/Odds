import 'package:flutter/material.dart';
import '../classes/bet_feed_item.dart';

class BetFeedList extends StatefulWidget {
  final List<Bet> listItems;
  BetFeedList(this.listItems);

  @override
  State<BetFeedList> createState() => _BetFeedListState();
}

class _BetFeedListState extends State<BetFeedList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var bet = widget.listItems[index];
        return Card(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: Text(bet.bettor + ' bets ' + bet.receiver),
                subtitle: Text(bet.betText),
              )),
              Column(
                children: <Widget>[
                  Text(bet.betterAmount.toString()),
                  Text("to win"),
                  Text(bet.receiverAmount.toString()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../classes/bet_feed_item.dart';

class MeFeedList extends StatefulWidget {
  List<Bet> listItems;
  final status;
  MeFeedList(this.listItems, this.status);

  @override
  State<MeFeedList> createState() => _MeFeedListState();
}

class _MeFeedListState extends State<MeFeedList> {
  void filterList() {
    if (widget.status == 1) {
      widget.listItems = widget.listItems
          .where((item) => item.status == 0 || item.status == 1)
          .toList();
    } else if (widget.status == 2) {
      widget.listItems =
          widget.listItems.where((item) => item.status == 2).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    filterList();

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
                  Text(bet.betterAmount.toString()),
                  Text("to win"),
                  Text(bet.receiverAmount.toString()),
                  bet.status == 0
                      ? Row(children: [
                          Text('Accept Bet: '),
                          Icon(Icons.check, color: Colors.green),
                          Icon(Icons.close, color: Colors.red)
                        ])
                      : Container(),
                  bet.status == 1
                      ? Row(children: [
                          Text('Concede Bet: '),
                          Icon(Icons.close, color: Colors.red)
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/bet_feed_item.dart';
import '../classes/bets_provider.dart';

class BetFeedList extends StatefulWidget {
  List<Bet> listItems;
  BetFeedList(this.listItems);

  @override
  State<BetFeedList> createState() => _BetFeedListState();
}

class _BetFeedListState extends State<BetFeedList> {
  void filterList(List<Bet> bets) {
    widget.listItems = bets
        .where(
            (item) => item.status == 0 || item.status == 1 || item.status == 2)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BetsProvider>(context);

    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var bet = widget.listItems[index];
        // if (bet.status == 0 || bet.status == 4) {
        //   return SizedBox.shrink(); // returns an empty widget
        // }
        return Card(
          color: bet.status == 1
              ? Color.fromARGB(255, 255, 251, 240)
              : Color.fromARGB(255, 255, 252, 242), //change to an accent color
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                    child: ListTile(
                  title: bet.status == 1
                      ? RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: bet.bettorName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: ' bets '),
                              TextSpan(
                                text: bet.receiverName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: bet.winner == 1
                                    ? bet.bettorName
                                    : bet.receiverName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: ' won a bet against '),
                              TextSpan(
                                text: bet.winner == 1
                                    ? bet.receiverName
                                    : bet.bettorName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                  subtitle: Text(bet.betText),
                )),
                Column(
                  children: <Widget>[
                    Text(
                      bet.bettorAmount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("to win"),
                    Text(
                      bet.receiverAmount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

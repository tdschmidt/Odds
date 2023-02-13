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
                  title: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: bet.bettor,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' bets '),
                        TextSpan(
                          text: bet.receiver,
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
                      bet.betterAmount.toString(),
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

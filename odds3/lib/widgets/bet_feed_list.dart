import 'package:firebase_auth/firebase_auth.dart';
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
    User? user = FirebaseAuth.instance.currentUser;
    final state = Provider.of<BetsProvider>(context);

    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var bet = widget.listItems[index];
        // if (bet.status == 4) {
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
                Row(children: [
                  // first the bettor then the receiver
                  Container(
                    height: 25.0,
                    width: 25.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(bet.bettorProfileUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Container(
                    height: 25.0,
                    width: 25.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(bet.receiverProfileUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ]),
                Expanded(
                    child: ListTile(
                  title: bet.status == 1 || bet.status == 0
                      ? RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: (user?.uid == bet.bettorId)
                                    ? "You"
                                    : bet.bettorName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: (user?.uid == bet.bettorId ||
                                          user?.uid == bet.receiverId)
                                      ? (bet.status == 1
                                          ? " bet "
                                          : " proposed ")
                                      : (bet.status == 1
                                          ? " bets "
                                          : " proposed ")),
                              TextSpan(
                                text: (user?.uid == bet.receiverId)
                                    ? "You"
                                    : bet.receiverName,
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
                                    ? ((user?.uid == bet.bettorId)
                                        ? "You"
                                        : bet.bettorName)
                                    : ((user?.uid == bet.receiverId)
                                        ? "You"
                                        : bet.receiverName),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: ' won a bet against '),
                              TextSpan(
                                text: bet.winner == 1
                                    ? ((user?.uid == bet.receiverId)
                                        ? "You"
                                        : bet.receiverName)
                                    : ((user?.uid == bet.bettorId)
                                        ? "You"
                                        : bet.bettorName),
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

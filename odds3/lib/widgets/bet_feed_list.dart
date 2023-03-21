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
    bets.sort((a, b) => b.timestampCreated.compareTo(a.timestampCreated));
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
        return Card(
          color: bet.status == 1
              ? Color.fromARGB(255, 255, 251, 240)
              : Color.fromARGB(255, 255, 252, 242),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Row(children: [
                  Container(
                    height: 25.0,
                    width: 25.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: (bet.status != 2
                            ? NetworkImage(bet.bettorProfileUrl)
                            : (bet.winner == true
                                ? NetworkImage(bet.receiverProfileUrl)
                                : NetworkImage(bet.bettorProfileUrl))),
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
                        image: (bet.status != 2
                            ? NetworkImage(bet.receiverProfileUrl)
                            : (bet.winner == true
                                ? NetworkImage(bet.bettorProfileUrl)
                                : NetworkImage(bet.receiverProfileUrl))),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ]),
                Expanded(
                    child: Align(
                        alignment: Alignment(0.0, 0.5),
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
                                        text: bet.winner == true
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
                                      TextSpan(text: ' won a bet against '),
                                      TextSpan(
                                        text: bet.winner == true
                                            ? ((user?.uid == bet.bettorId)
                                                ? "you"
                                                : bet.bettorName)
                                            : ((user?.uid == bet.receiverId)
                                                ? "you"
                                                : bet.receiverName),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          subtitle: Text(
                            bet.betText,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                        ))),
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

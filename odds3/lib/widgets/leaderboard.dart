import 'package:flutter/material.dart';
import '../classes/user.dart';

class Leaderboard extends StatefulWidget {
  final List<User> listItems;
  Leaderboard(this.listItems);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${index + 1}'),
                Text(widget.listItems[index].name),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Bets Won'),
                    Text('${widget.listItems[index].betsWon}'),
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

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
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.listItems[index].name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${widget.listItems[index].tokens}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 4),
                        Image.network(
                          'https://img.icons8.com/external-vectorslab-flat-vectorslab/512/external-Casino-Token-casino-vectorslab-flat-vectorslab.png',
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${widget.listItems[index].betsWon} - ${widget.listItems[index].betsLost}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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

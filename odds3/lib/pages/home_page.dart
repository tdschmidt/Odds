import 'package:flutter/material.dart';
import 'package:odds3/pages/add_friends_page.dart';
import 'package:odds3/widgets/leaderboard.dart';
import '../widgets/bet_feed_list.dart';
import '../widgets/toggle_switch.dart';
import '../dummy_data.dart';
import '../widgets/add_friends_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _toggleValue = 0;

  void _updateToggleValue(int index) {
    setState(() {
      _toggleValue = index;
    });
  }

  void onAddFriends() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddFriendsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddFriendsButton(onPressed: onAddFriends),
        Container(
          child: MyToggleSwitch(
              onChanged: _updateToggleValue, label: _toggleValue),
        ),
        _toggleValue == 0
            ? Expanded(child: BetFeedList(bets))
            : Expanded(child: Leaderboard(users)),
      ],
    );
  }
}

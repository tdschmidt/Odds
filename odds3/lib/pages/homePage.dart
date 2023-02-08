import 'package:flutter/material.dart';
import 'package:odds3/pages/addFriendsPage.dart';
import 'package:odds3/widgets/leaderboard.dart';
import '../widgets/betFeedList.dart';
import '../widgets/toggleSwitch.dart';
import '../dummyData.dart';
import '../widgets/addFriendsButton.dart';

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

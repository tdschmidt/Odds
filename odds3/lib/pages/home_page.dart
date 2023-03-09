import 'package:flutter/material.dart';
import 'package:odds3/classes/friend_request_provider.dart';
import 'package:odds3/pages/add_friends_page.dart';
import 'package:odds3/widgets/leaderboard.dart';
//import '../lib/pages/home_page.dart';
import '../widgets/bet_feed_list.dart';
import '../widgets/toggle_switch.dart';
import '../dummy_data.dart';
import '../widgets/add_friends_button.dart';
import 'package:provider/provider.dart';
import 'package:odds3/classes/bets_provider.dart';

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
    final stateFriendRequests =
        Provider.of<FriendRequestProvider>(context, listen: false);
    stateFriendRequests.fetchFriendRequest();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddFriendsPage(stateFriendRequests.friend_requests)));
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BetsProvider>(context);
    state.fetchFriendBets();

    return Column(
      children: [
        AddFriendsButton(onPressed: onAddFriends),
        Container(
          child: MyToggleSwitch(
              onChanged: _updateToggleValue, label: _toggleValue),
        ),
        _toggleValue == 0
            ? Expanded(
                child: Consumer<BetsProvider>(builder: (context, state, _) {
                return BetFeedList(state.friendBets);
              }))
            : Expanded(child: Leaderboard(users)),
      ],
    );
  }
}

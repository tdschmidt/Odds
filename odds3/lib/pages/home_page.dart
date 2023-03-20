import 'package:flutter/material.dart';
import 'package:odds3/classes/friend_request_provider.dart';
import 'package:odds3/pages/add_friends_page.dart';
import 'package:odds3/widgets/leaderboard.dart';
//import '../lib/pages/home_page.dart';
import '../widgets/bet_feed_list.dart';
import '../widgets/toggle_switch.dart';
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
    stateFriendRequests.fetchFriendRequests();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddFriendsPage(stateFriendRequests.friend_requests)));
  }

  @override
  Widget build(BuildContext context) {
    // final userFriend = Provider.of<UserFriendsProvider>(context);
    final state = Provider.of<BetsProvider>(context);
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 12.5),
                child: Image.asset(
                  'assets/OddsLogoWhite.jpg',
                  height: 60,
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: AddFriendsButton(onPressed: onAddFriends),
            ),
          ],
        ),
        Container(
          child: MyToggleSwitch(
              onChanged: _updateToggleValue, label: _toggleValue),
        ),
        _toggleValue == 0
            ? Expanded(
                child: Consumer<BetsProvider>(builder: (context, state, _) {
                return BetFeedList(state.friendBets);
              }))
            : Expanded(child: Leaderboard()),
      ],
    );
  }
}

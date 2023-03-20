import 'package:flutter/material.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:odds3/classes/friend_request_provider.dart';
import 'package:provider/provider.dart';
import 'classes/bets_provider.dart';
import 'classes/cur_user_friends_provider.dart';
import 'pages/home_page.dart';
import 'pages/bet_page.dart';
import 'pages/add_friends_page.dart';
import 'pages/me_page.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final screens = [HomePage(), BetPage(), MePage()];

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<CurUserProvider>(context);
    final betState = Provider.of<BetsProvider>(context);
    final friendsState = Provider.of<UserFriendsProvider>(context);
    final friendRequestsState = Provider.of<FriendRequestProvider>(context);
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => currentIndex = index);
            if (index == 0) {
              betState.fetchFriendBets();
              betState.fetchBets();
              friendsState.fetchFriends();
              friendRequestsState.fetchFriendRequests();
            } else if (index == 2) {
              userState.fetchCurUser();
              betState.fetchBets();
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.handshake),
                label: "Wager",
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Me",
                backgroundColor: Colors.blue)
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classes/bets_provider.dart';
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
    final betState = Provider.of<BetsProvider>(context);
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => currentIndex = index);
            if (index == 0) {
              betState.fetchFriendBets();
            } else if (index == 2) {
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

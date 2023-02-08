import 'package:flutter/material.dart';
import 'pages/homePage.dart';
import 'pages/betPage.dart';
import 'pages/addFriendsPage.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final screens = [
    HomePage(),
    BetPage(),
    Center(
        child: Text(
      'Profile',
      style: TextStyle(fontSize: 60),
    ))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
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

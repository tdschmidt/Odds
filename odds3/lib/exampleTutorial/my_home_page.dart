import 'package:flutter/material.dart';
import 'post.dart';
import 'textInputWidget.dart';
import 'post_list.dart';

class MyHomePage extends StatefulWidget {
  final String name;

  const MyHomePage(this.name);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];
  int currentIndex = 0;

  void newPost(String text) {
    setState(() {
      posts.add(new Post(text, widget.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello World")),
      body: Column(
        children: <Widget>[
          Expanded(child: PostList(this.posts)),
          TextInputWigdet(this.newPost),
        ],
      ),
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

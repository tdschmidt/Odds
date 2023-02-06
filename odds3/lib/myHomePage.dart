import 'package:flutter/material.dart';
import 'post.dart';
import 'textInputWidget.dart';
import 'postList.dart';

class MyHomePage extends StatefulWidget {
  final String name;

  const MyHomePage(this.name);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  void newPost(String text) {
    this.setState(() {
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
        ));
  }
}

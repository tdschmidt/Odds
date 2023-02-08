import 'package:flutter/material.dart';

class TextInputWigdet extends StatefulWidget {
  final Function(String) callback;

  TextInputWigdet(this.callback);
  @override
  State<TextInputWigdet> createState() => _TextInputWigdetState();
}

class _TextInputWigdetState extends State<TextInputWigdet> {
  final controller = TextEditingController();
  String text = "";

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void click() {
    widget.callback(controller.text);
    FocusScope.of(context).unfocus();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return (TextField(
        controller: this.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.message),
          labelText: "Type a message: ",
          suffixIcon: IconButton(
              icon: Icon(Icons.send),
              splashColor: Colors.blue,
              tooltip: "Post Message",
              onPressed: () => click()),
        )));
  }
}

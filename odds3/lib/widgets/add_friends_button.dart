import 'package:flutter/material.dart';

class AddFriendsButton extends StatelessWidget {
  final Function onPressed;
  const AddFriendsButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(top: 40, right: 10),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          mini: true,
          onPressed: () {
            onPressed();
          },
          child: Icon(Icons.person_add_alt_1_outlined),
        ),
      ),
    );
  }
}

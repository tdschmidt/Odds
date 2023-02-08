import 'package:flutter/material.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  final _friendNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextField(
              controller: _friendNameController,
              decoration: InputDecoration(
                hintText: 'Enter friend name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // add friend logic here
                print('Friend name: ${_friendNameController.text}');
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

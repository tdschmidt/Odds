import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/user_info_screen.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  // Instantiating the user for when we have to add friends to the user's subcollection
  User? user = FirebaseAuth.instance.currentUser;
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
              onPressed: () async {
                // Lookup user in Firestore
                var friendName = _friendNameController.text;
                print("Friend name: $friendName");
                // This checks whether the username matches a user in our database
                var querySnapShot = await FirebaseFirestore.instance.collection("users").where('username', isEqualTo: friendName).get();
                // This is the case where we get no matches
                if (querySnapShot.docs.isEmpty) {
                  print("No user found with name $friendName");
                } else {
                  // This is the case where a match was found
                  // Here we will have to implement the friend request process
                  print("User found: ${querySnapShot.docs.first.data()}");
                }
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
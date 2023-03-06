import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/user_info_screen.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
  List<FriendRequest> listItems; //Make friendrequest type
  AddFriendsPage(this.listItems);
}

enum FriendStatus { ACCEPTED, DECLINED, OPEN }

class _AddFriendsPageState extends State<AddFriendsPage> {
  // Instantiating the user for when we have to add friends to the user's subcollection
  User? user = FirebaseAuth.instance.currentUser;
  final _friendNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Add a Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _friendNameController,
              decoration: InputDecoration(
                labelText: 'Enter friend name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Lookup user in Firestore
                var friendName = _friendNameController.text;
                print("Friend name: $friendName");
                // This checks whether the username matches a user in our database
                var querySnapShot = await FirebaseFirestore.instance
                    .collection("users")
                    .where('username', isEqualTo: friendName)
                    .get();

                var querySnapShotInviter = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user?.uid)
                    .get();
                // This is the case where we get no matches
                if (querySnapShot.docs.isEmpty) {
                  print("No user found with name $friendName");
                } else {
                  // This is the case where a match was found
                  // Here we will have to implement the friend request process
                  print("User found: ${querySnapShot.docs.first.data()}");
                  var friendRequested = querySnapShot.docs.first.data();
                  var friendInviter = querySnapShotInviter.data();
                  // Checking if the user already made that request before
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(friendRequested['userId'])
                      .collection("friendInvites")
                      .where('Inviter', isEqualTo: user?.uid)
                      .get()
                      .then((friendDocs) {
                    if (friendDocs.docs.isNotEmpty) {
                      print("Friend request already exists");
                    } else {
                      // get's info on current user

                      // Add friend request logic here
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendRequested['userId'])
                          .collection('friendInvites')
                          .add({
                        "Inviter": friendInviter?['userId'],
                        "InviterName": friendInviter?['fullName'],
                        "Receiver": friendRequested['userId'],
                        "ReceiverName": friendRequested['fullName'],
                        "DateCreated": Timestamp.now().millisecondsSinceEpoch,
                        "Status": FriendStatus.OPEN.index,
                      });

                      // adding the friend request info to both users' data
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendInviter?['userId'])
                          .collection('friendInvites')
                          .add({
                        "Inviter": friendInviter?['userId'],
                        "InviterName": friendInviter?['fullName'],
                        "Receiver": friendRequested['userId'],
                        "ReceiverName": friendRequested['fullName'],
                        "DateCreated": Timestamp.now().millisecondsSinceEpoch,
                        "Status": FriendStatus.OPEN.index,
                      });
                      print("Added friend");
                    }
                  });
                }
                print('Friend name: ${_friendNameController.text}');
              },
              child: Text(
                'Add Friend',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 16.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            ListView.builder(
                itemCount: widget.listItems.length,
                itemBuilder: (context, index) {
                  var bet = widget.listItems[index];
                  return Card(
                      //PUT REPRESENTATION OF FRIEND REQUEST HERE
                      );
                })
          ],
        ),
      ),
    );
  }
}

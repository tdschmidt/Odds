import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:odds3/classes/friend_request_item.dart';
import 'package:odds3/classes/friend_request_provider.dart';
import 'package:odds3/widgets/friend_request_feed_list.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:odds3/classes/friend_request_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/user_info_screen.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AddFriendsPage extends StatefulWidget {

  List<FriendRequest> listItems;
  AddFriendsPage(this.listItems);

  @override
  State<AddFriendsPage> createState() => _AddFriendsPage();

}

enum FriendStatus { ACCEPTED, DECLINED, OPEN }

class _AddFriendsPage extends State<AddFriendsPage> {
  // Instantiating the user for when we have to add friends to the user's subcollection
  User? user = FirebaseAuth.instance.currentUser;
  final _friendNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    
    final state = Provider.of<FriendRequestProvider>(context);

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
                      .where('inviterId', isEqualTo: user?.uid)
                      .get()
                      .then((friendDocs) {
                    if (friendDocs.docs.isNotEmpty) {
                      print("Friend request already exists");
                    } else {
                      // get's info on current user
                      var inviterId = friendInviter?['userId'];
                      var inviterName = friendInviter?['fullName'];
                      var receiverId = friendRequested['userId'];
                      var receiverName = friendRequested['fullName'];
                      var timestampCreated = Timestamp.now().millisecondsSinceEpoch;;
                      var status = 2;

                      String idStringInput = inviterId + receiverId + timestampCreated.toString();
                      List<int> plaintextBytes = utf8.encode(idStringInput); // Convert the string to a list of bytes
                      Digest sha1FriendRequestHash = sha1.convert(plaintextBytes);
                      String friendRequestId = sha1FriendRequestHash.toString();

                      FriendRequest curr_friend_request = FriendRequest(id: friendRequestId, inviterId: inviterId, inviterName: inviterName, receiverId: receiverId, receiverName: receiverName, timestampCreated: timestampCreated, status: status);
                      state.makeFriendRequest(curr_friend_request);
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
            //Text("Friend Requests"),
            Expanded(child:
                Consumer<FriendRequestProvider>(builder: (context, state, _) {
              return FriendRequestList(state.friend_requests);
            }))
          ],
        ),
      ),
    );
  }
}

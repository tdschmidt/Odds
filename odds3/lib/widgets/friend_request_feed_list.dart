import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/friend_request_item.dart';
import '../classes/friend_request_provider.dart';
import '../classes/cur_user_provider.dart';
import '../classes/user.dart';

class FriendRequestList extends StatefulWidget {
  List<FriendRequest> listItems;
  FriendRequestList(this.listItems);

  @override
  State<FriendRequestList> createState() => _FriendRequestList();
}

// Creation of the card
// Can access the necessary variables through the FriendRequest class in friend_request_item.dart
//NEED TO FILTER BY OPEN FRIEND REQUESTS, AND BY USER
class _FriendRequestList extends State<FriendRequestList> {
  void filterList(List<FriendRequest> friend_requests, CurUser? user) {
    widget.listItems = friend_requests
        .where((item) => item.status == 2)
        .where((element) =>
            element.receiverId ==
            user?.uid) // || item.status == 1 || item.status == 2)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<FriendRequestProvider>(context);
    final stateUser = Provider.of<CurUserProvider>(context);
    stateUser.fetchCurUser();
    filterList(state.friend_requests, stateUser.curUser);
    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var friendRequest = widget.listItems[index];
        return Card(
          color: Color.fromARGB(255, 255, 252, 242),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: friendRequest.inviterName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' has sent you a friend request.'),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    // Placeholder method for handling clicks on the green checkmark icon
                    state.acceptFriendRequest(friendRequest);
                    print("Accepted friend request.");
                  },
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    // Placeholder method for handling clicks on the red X icon
                    state.rejectFriendRequest(friendRequest);
                    print("Declined friend request.");
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../classes/user.dart';
import '';

class UserProfile extends StatelessWidget {
  final User user;
  const UserProfile(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40.0, left: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 10.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  user.username,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                )),
          ),
          Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Center(
              child: Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgf3gg-20x4jBxpqsEl8BNYLniItxU0ZdW5-UpeSws4A&s"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.coins.toString(),
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5.0),
                Icon(
                  Icons.monetization_on,
                  size: 22.0,
                  color: Colors.yellow,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0, left: 0.0),
            child: Text(
              user.betsLost.toString() + '-' + user.betsLost.toString(),
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

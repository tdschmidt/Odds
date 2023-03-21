import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:odds3/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';
import '../classes/bets_provider.dart';
import '../classes/user.dart';
import '../utils/authentication.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<CurUserProvider>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 22,
                  left: 18.0,
                  right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userState.curUser?.fullName ?? '',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '@${userState.curUser?.username ?? ''}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey,
                              ),
                            )),
                      ),
                    ],
                  ),
                  _isSigningOut
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : SizedBox(
                          width: 100, // desired width
                          height: 30, // desired height
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 184, 74, 43)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )),
                            onPressed: () async {
                              setState(() {
                                _isSigningOut = true;
                              });
                              await Authentication.signOut(context: context);
                              setState(() {
                                _isSigningOut = false;
                              });
                              Navigator.of(context)
                                  .pushReplacement(_routeToSignInScreen());
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 0),
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              )),
          userState.curUser?.photoURL != null
              ? Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey.withOpacity(0.3),
                      child: Image.network(
                        userState.curUser!.photoURL!,
                        fit: BoxFit.fitHeight,
                        width: 150.0,
                      ),
                    ),
                  ))
              : Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey.withOpacity(0.3),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.person,
                          size: 125,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )),
          Container(
            padding: EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userState.curUser?.tokens.toString() ?? '',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Image.network(
                    'https://img.icons8.com/external-vectorslab-flat-vectorslab/512/external-Casino-Token-casino-vectorslab-flat-vectorslab.png',
                    width: 20,
                    height: 20,
                  ),
                  onPressed: null,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 3, bottom: 10.0, left: 0.0),
            child: Text(
              (userState.curUser?.betsWon.toString() ?? '') +
                  '-' +
                  (userState.curUser?.betsLost.toString() ?? ''),
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

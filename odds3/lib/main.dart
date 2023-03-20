import 'package:flutter/material.dart';
import 'package:odds3/classes/cur_user_friends_provider.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:provider/provider.dart';
import 'classes/bets_provider.dart';
import 'classes/friend_request_provider.dart';
import 'main_page.dart';
import 'screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => BetsProvider()
                ..fetchBets()
                ..fetchFriendBets()),
          ChangeNotifierProvider(create: (context) => CurUserProvider()),
          ChangeNotifierProvider(
              create: (context) =>
                  FriendRequestProvider()..fetchFriendRequests()),
          ChangeNotifierProvider(
              create: (context) => UserFriendsProvider()..fetchFriends()),
        ],
        child: MaterialApp(
          title: 'Odds',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              //primarySwatch: Colors.indigo,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                  //colors should come from this in future but for now I have hard coded colors
                  seedColor: Color.fromARGB(255, 251, 230, 184),
                  primary: Color.fromARGB(255, 184, 74, 43),
                  secondary: Color.fromARGB(255, 255, 251, 240))),
          home: CurUserProvider().isAuthenticated ? MainPage() : SignInScreen(),
        ));
  }
}

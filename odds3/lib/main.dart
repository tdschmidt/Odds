import 'package:flutter/material.dart';
import 'package:odds3/classes/cur_user_provider.dart';
import 'package:provider/provider.dart';
import 'classes/bets_provider.dart';
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
              create: (context) => BetsProvider()..fetchBets()),
          ChangeNotifierProvider(create: (context) => CurUserProvider()),
        ],
        child: MaterialApp(
          title: 'Odds',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            brightness: Brightness.dark,
          ),
          home: CurUserProvider().isAuthenticated ? MainPage() : SignInScreen(),
        ));
  }
}

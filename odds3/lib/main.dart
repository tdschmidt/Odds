import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classes/state_management.dart';
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
<<<<<<< HEAD
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Color.fromARGB(255, 27, 135, 223),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
=======
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => StateManagement()..fetchBets()),
        ],
        child: MaterialApp(
          title: 'Odds',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            brightness: Brightness.dark,
          ),
          home: SignInScreen(),
        ));
>>>>>>> 86faf0b125ee293cc93d801c5ba6a4647b60154e
  }
}

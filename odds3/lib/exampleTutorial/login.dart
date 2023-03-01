import 'package:flutter/material.dart';
import 'my_home_page.dart';
import '../main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Hello World")), body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String name;
  TextEditingController controller = TextEditingController();
// switch between main page and app by toggling this route
  void click() {
    name = controller.text;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: "Type your name: ",
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 5, color: Colors.black)),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.done),
                    splashColor: Colors.blue,
                    tooltip: "Submit",
                    onPressed: click),
              ),
            )));
  }
}

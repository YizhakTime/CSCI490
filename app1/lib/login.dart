import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Login into Language Learner'),
        elevation: 0.0,
      ),
      body: Container(
          color: Colors.cyan,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
          child: ElevatedButton(
            child: const Text("Sign-up"),
            onPressed: () async {},
          )),
    );
  }
}

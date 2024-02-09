import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class MyUser {}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = "Language Learner";
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        backgroundColor: const Color(0xff6750a4),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SignOutButton()
          ],
        ),
      ),
    );
  }
}

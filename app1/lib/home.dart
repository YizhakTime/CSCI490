import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class MyUser {
  late String id;
  // MyUser({this.id})
}

class Home extends StatelessWidget {
  const Home({super.key, required this.user});

  final User? user;
  @override
  Widget build(BuildContext context) {
    const String appTitle = "Language Learner";
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
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

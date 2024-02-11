import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class MyUser {
  late String id;
  // MyUser({this.id})
}

//String greeting => "Hello";
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
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
        automaticallyImplyLeading: true,
        title: const Text(appTitle),
        centerTitle: true,
        backgroundColor: const Color(0xff6750a4),
      ),
      drawer: SizedBox(
        width: 230,
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff6750a4),
                ),
                child: Text(
                  "Options",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              // ListTile(
              //   title: const Text("Notes"),
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              // ),
              ListTile(
                title: const Text("Sign-out"),
                onTap: () {
                  const SignOutButton();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SignOutButton(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff6750a4),
        child: const Icon(Icons.camera),
      ),
    );
  }
}

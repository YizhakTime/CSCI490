import 'package:app1/translate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
// import 'package:simplytranslate/simplytranslate.dart';

class MyUser {
  late String id;
  // MyUser({this.id})
}

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

class Vision extends StatefulWidget {
  const Vision({super.key});

  @override
  State<Vision> createState() => _VisionState();
}

class _VisionState extends State<Vision> {
  late FlutterVision vision;
  Options option = Options.none;
  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//String greeting => "Hello";

class Home extends StatelessWidget {
  Home({super.key, required this.user});
  final FirebaseAuth myuser = FirebaseAuth.instance;

  Future<void> signOut(BuildContext context) async {
    await myuser.signOut();
  }

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
                const SizedBox(
                  height: 135,
                  child: DrawerHeader(
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
                ),
                ListTile(
                    title: const Text("Sign-out"),
                    leading: const Icon(Icons.logout),
                    onTap: () {
                      signOut(context);
                    }),
              ],
            ),
          ),
        ),
        body: const Center(
          child: Column(
            children: [
              Text(
                'Welcome To Language Learner!',
                style: TextStyle(fontSize: 30),
              ),
              Text("Press the Translate button to translate anything you want!")
            ],
          ),
        ),
        floatingActionButton: Row(children: [
          FloatingActionButton(
            onPressed: () {},
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff6750a4),
            child: const Icon(Icons.camera),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Translatepage()),
              );
              // translate();
            },
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff6750a4),
            child: const Icon(Icons.translate),
          ),
        ]));
  }
}

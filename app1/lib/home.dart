import 'package:app1/camera.dart';
import 'package:app1/translate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
// import 'package:simplytranslate/simplytranslate.dart';

class MyUser {
  late String id;
  // MyUser({this.id})
}

class Notes {
  final String input;
  final String output;

  Notes(this.input, this.output);
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
    // final size = MediaQuery.of(context).size;
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
                      ], //actions
                    ),
                  ),
                );
              },
            )
          ],
          automaticallyImplyLeading: true,
          title: const Text(
            appTitle,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff6750a4),
        ),
        drawer: SizedBox(
          width: 230,
          child: Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const DisplayImage(
                image: 'images/test1.png',
              ),
              const NoteTitle(label: "My Notecards"),
              // const Text(
              //   'Welcome To Language Learner!',
              //   style: TextStyle(fontSize: 30),
              // ),
              // const Text(
              //     "Press the Translate button to translate anything you want!"),
              Wrap(
                direction: Axis.vertical,
                children: List.generate(3, (index) => const Text("hello")),
              )
            ],
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          // const Spacer(),
          FloatingActionButton(
            heroTag: "w",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Vision()),
              );
            },
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff6750a4),
            child: const Icon(Icons.camera),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "a",
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
        ] //children

                ));
  } //build
} //Home

class NoteTitle extends StatelessWidget {
  const NoteTitle({
    super.key,
    required this.label,
  });
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          )),
          Icon(
            Icons.sticky_note_2,
            size: 45,
            color: Colors.red[450],
          )
        ],
      ),
    );
  }
}

class DisplayImage extends StatelessWidget {
  const DisplayImage({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: 500,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}

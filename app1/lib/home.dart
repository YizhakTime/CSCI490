import 'dart:async';

import 'package:app1/camera.dart';
import 'package:app1/translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:simplytranslate/simplytranslate.dart';

class MyUser {
  late String id;
  // MyUser({this.id})
}

class MyNotes extends ChangeNotifier {
  bool flag = false;
  String srcString = "";
  String tarString = "";
  String srcLang = "en";
  String tarLang = "";
  bool get myflag => flag;
  String get selSrc => srcString;
  String get selTar => tarString;
  String get selSrcLang => srcLang;
  String get selTarLang => tarLang;

  void setSrc(String tmpSrc) {
    srcString = tmpSrc;
    notifyListeners();
  }

  void setTar(String tmpTar) {
    tarString = tmpTar;
    notifyListeners();
  }

  void setSrcLang(String tmpSrcLang) {
    srcLang = tmpSrcLang;
    notifyListeners();
  }

  void setTarLang(String tmpTarLang) {
    tarLang = tmpTarLang;
    notifyListeners();
  }

  void setFlag(bool tmp) {
    flag = tmp;
    notifyListeners();
  }
}

class FlagProvider with ChangeNotifier {
  bool flag = true;
  bool get myFlag => flag;

  void setFlag(bool myFlag) {
    flag = myFlag;
    notifyListeners();
  }
}

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key, required this.user});
  final User? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth myuser = FirebaseAuth.instance;
  bool flag = true;
  List<Notecard> list = [];

  void addNoteCard(String t1, String t2, String t3, String t4, bool state) {
    setState(() {
      if (state) {
        list.add(Notecard(
          input: t1,
          output: t2,
          inLang: t3,
          outLang: t4,
        ));
      } else {
        final snackBar = SnackBar(
          content: const Text('Translation does not exist'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
          duration: const Duration(milliseconds: 600),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  void removeNoteCard() {
    setState(() {
      if (list.isNotEmpty) {
        list.remove(list.last);
      }
    });
  }

  Future<void> signOut(BuildContext context) async {
    await myuser.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    const String appTitle = "Language Learner";
    return
        // ChangeNotifierProvider<MyNotes>(
        //   create: (_) => MyNotes(),
        //   builder: (context, child) =>
        // child:
        Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<ProfileScreen>(
                    builder: (context) => ChangeNotifierProvider<FlagProvider>(
                      create: (context) => FlagProvider(),
                      builder: (context, child) => ProfileScreen(
                        appBar: AppBar(
                          title: const Text('User Profile'),
                        ),
                        actions: [
                          SignedOutAction((context) {
                            Navigator.of(context).pop();
                          })
                        ],
                        children: [
                          ElevatedButton(
                              onPressed: () => setState(() {
                                    flag = !flag;
                                    Provider.of<FlagProvider>(context,
                                            listen: false)
                                        .setFlag(flag);
                                  }),
                              child: const Text("Hide or Show")),
                          Visibility(
                            visible: context.watch<FlagProvider>().flag,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('translation_notecards')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                if (!streamSnapshot.hasData) {
                                  return const Text("Loading..");
                                }
                                return SingleChildScrollView(
                                  physics: const ScrollPhysics(),
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) => Notecard(
                                          input: streamSnapshot
                                              .data!.docs[index]['input_text'],
                                          output: streamSnapshot
                                              .data!.docs[index]['output_text'],
                                          inLang: streamSnapshot
                                              .data!.docs[index]['inLang'],
                                          outLang: streamSnapshot
                                              .data!.docs[index]['outLang'])),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
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
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const DisplayImage(
              image: 'images/test1.png',
            ),
            const NoteTitle(label: "Photo Notecards"),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return list[index];
                }),
          ],
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          width: 15,
        ),
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
          },
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xff6750a4),
          child: const Icon(Icons.translate),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            addNoteCard(
                Provider.of<MyNotes>(context, listen: false).selSrc,
                Provider.of<MyNotes>(context, listen: false).selTar,
                Provider.of<MyNotes>(context, listen: false).selSrcLang,
                Provider.of<MyNotes>(context, listen: false).selTarLang,
                Provider.of<MyNotes>(context, listen: false).myflag
                // context.watch<MyNotes>().selSrc,
                // context.watch<MyNotes>().selTar,
                // "en",
                // context.watch<MyNotes>().selTarLang,
                // context.watch<MyNotes>().flag
                );
          },
          child: const Text("Add card"),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 100,
          child: FloatingActionButton(
              heroTag: "nfe",
              onPressed: () {
                if (list.isNotEmpty) {
                  removeNoteCard();
                } else {
                  final snackBar = SnackBar(
                    content: const Text('List is empty'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                    duration: const Duration(milliseconds: 600),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text("Remove Card")),
        ),
      ] //children
              ),
    );
  }
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

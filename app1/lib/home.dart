import 'dart:async';
import 'package:app1/camera.dart';
import 'package:app1/translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool beginFlag = true;
  bool get myImageFlag => beginFlag;
  bool get myFlag => flag;

  void setFlag(bool myFlag) {
    flag = myFlag;
    notifyListeners();
  }

  void setImageFlag(bool tmpFlag) {
    beginFlag = tmpFlag;
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
  bool imageflag = true;
  List<Notecard> list = [];
  int currentIndex = 0;

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
          content: const Text('Image translation does not exist'),
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

  Future<DocumentReference> storeNotes(
      String text1, String text2, String text3, String text4, bool flag) {
    if (!flag) {
      final snackBar = SnackBar(
        content: const Text('Translation does not exist'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
        duration: const Duration(milliseconds: 600),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception("Notecard list is empty");
    }

    //Note, need to consider list of notecards, only save current notecard
    return FirebaseFirestore.instance
        .collection("image_notecards")
        .add(<String, dynamic>{
      'src_lang': text1,
      'src_text': text2,
      'tar_lang': text3,
      'tar_text': text4,
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
                    builder: (context, child) =>
                        // child:
                        ProfileScreen(
                      appBar: AppBar(
                        title: const Text('User Profile'),
                      ),
                      actions: [
                        SignedOutAction((context) {
                          Navigator.of(context).pop();
                        })
                      ],
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Translation notecards",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontStyle: FontStyle.normal,
                                ))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Column(
                        //   children: [
                        ElevatedButton(
                            onPressed: () => setState(() {
                                  flag = !flag;
                                  Provider.of<FlagProvider>(context,
                                          listen: false)
                                      .setFlag(flag);
                                }),
                            child:
                                const Text("Hide/Show Translation Notecards")),
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
                                    itemCount: streamSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) => Notecard(
                                        input: streamSnapshot.data!.docs[index]
                                            ['input_text'],
                                        output: streamSnapshot.data!.docs[index]
                                            ['output_text'],
                                        inLang: streamSnapshot.data!.docs[index]
                                            ['inLang'],
                                        outLang: streamSnapshot
                                            .data!.docs[index]['outLang'])),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Image notecards",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontStyle: FontStyle.normal,
                                ))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () => setState(() {
                                  imageflag = !imageflag;
                                  Provider.of<FlagProvider>(context,
                                          listen: false)
                                      .setImageFlag(imageflag);
                                }),
                            child: const Text("Hide/Show Image Notecards")),
                        Visibility(
                          visible: context.watch<FlagProvider>().beginFlag,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('image_notecards')
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
                                    itemCount: streamSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) => Notecard(
                                        input: streamSnapshot.data!.docs[index]
                                            ['src_text'],
                                        output: streamSnapshot.data!.docs[index]
                                            ['tar_text'],
                                        inLang: streamSnapshot.data!.docs[index]
                                            ['src_lang'],
                                        outLang: streamSnapshot
                                            .data!.docs[index]['tar_lang'])),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // ),
                // )
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
      bottomNavigationBar: SizedBox(
        height: 90,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) =>
                  states.contains(MaterialState.selected)
                      ? const TextStyle(color: Colors.white)
                      : const TextStyle(color: Colors.black),
            ),
          ),
          child: NavigationBar(
            backgroundColor: const Color(0xff6750a4),
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.home,
                ),
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                label: 'Vision',
              ),
              NavigationDestination(
                icon: Badge(
                    child: Icon(
                  Icons.translate,
                  color: Colors.black,
                )),
                label: 'Translation',
              ),
            ],
            onDestinationSelected: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            indicatorColor: const Color.fromARGB(255, 244, 223, 247),
            selectedIndex: currentIndex,
          ),
        ),
      ),
      body: IndexedStack(index: currentIndex, children: [
        SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const DisplayImage(
                image: 'images/test1.png',
              ),
              const NoteTitle(label: "Photo Notecards"),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  width: 20,
                ),
                ElevatedButton(
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
              ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        storeNotes(
                            Provider.of<MyNotes>(context, listen: false)
                                .selSrcLang,
                            Provider.of<MyNotes>(context, listen: false).selSrc,
                            Provider.of<MyNotes>(context, listen: false)
                                .selTarLang,
                            Provider.of<MyNotes>(context, listen: false).selTar,
                            Provider.of<MyNotes>(context, listen: false)
                                .myflag);
                      },
                      child: const Text("Click to store notecards"))
                ],
              ),
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
        const Vision(),
        const Translatepage(),
      ]),
      floatingActionButton:
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Text("eh"),
        // const SizedBox(
        //   width: 15,
        // ),
        // FloatingActionButton(
        //   heroTag: "w",
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const Vision()),
        //     );
        //   },
        //   foregroundColor: Colors.white,
        //   backgroundColor: const Color(0xff6750a4),
        //   child: const Icon(Icons.camera),
        // ),
        // const SizedBox(width: 10),
        // FloatingActionButton(
        //   heroTag: "a",
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const Translatepage()),
        //     );
        //   },
        //   foregroundColor: Colors.white,
        //   backgroundColor: const Color(0xff6750a4),
        //   child: const Icon(Icons.translate),
        // ),
        // const SizedBox(
        //   width: 10,
        // ),
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

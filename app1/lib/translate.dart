import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

enum LanguageLabel {
  spanish("es"),
  english("en"),
  german("de"),
  italian("it"),
  persian("fa"),
  turkish("tr"),
  japanese("ja"),
  french("fr"),
  korean("ko"),
  hindi("hi"),
  dutch("nl"),
  portuguese("pt"),
  russian("ru"),
  arabic("ar"),
  malay("ms"),
  indonesian("id"),
  hebrew("iw");

  const LanguageLabel(this.label);
  final String label;
}

class Notes {
  final String text;
  final String translation;
  Notes(this.text, this.translation);
}

class TranslationProvider with ChangeNotifier {
  String _inputText = "";
  String _translatedText = "";
  String get input => _inputText;
  String get output => _translatedText;

  void setInput(String value) {
    _inputText = value;
    notifyListeners();
  }

  void setTranslation(String val) {
    _translatedText = val;
    notifyListeners();
  }
}

// ignore: must_be_immutable
class Notecard extends StatelessWidget {
  String input;
  String output;
  String inLang;
  String outLang;
  Notecard(
      {super.key,
      required this.input,
      required this.output,
      required this.inLang,
      required this.outLang});
  @override
  Widget build(BuildContext context) {
    // final testProvider = Provider.of<MyProvider>(context, listen: true);
    // final language = Provider.of<TranslationProvider>(context, listen: true);
    // print("HEY:${language._inputText}");
    // print("No: ${language._translatedText}");
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
          elevation: 0.0,
          margin: const EdgeInsets.only(
              left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
          color: const Color.fromARGB(0, 237, 237, 237),
          child: FlipCard(
              direction: FlipDirection.HORIZONTAL,
              side: CardSide.FRONT,
              speed: 900,
              front: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 244, 223, 247),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          style: GoogleFonts.firaSansExtraCondensed(
                              textStyle:
                                  Theme.of(context).textTheme.displaySmall),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Base Language: $inLang \n",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "Text: $input")
                          ]),
                    )
                    // Text("Input Language: $inLang\nText: $input",
                    //     // "From: ${testProvider._option.label} => ${language._inputText}",
                    //     // Text("hello",
                    //     style:
                    // GoogleFonts.firaSansExtraCondensed(
                    //         textStyle:
                    //             Theme.of(context).textTheme.displaySmall)
                    // ),
                    // Text(testProvider._option2.label,
                    //     style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              back: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 244, 223, 247),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text("Hi",
                    // "To: ${testProvider._option2.label} => ${language._translatedText}",
                    RichText(
                      text: TextSpan(
                          style: GoogleFonts.firaSansExtraCondensed(
                              textStyle:
                                  Theme.of(context).textTheme.displaySmall),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Goal Language: $outLang \n",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "Text: $output")
                          ]),
                    )
                    // Text("Target Language: $outLang\nTranslation: $output",
                    //     style: GoogleFonts.firaSansExtraCondensed(
                    //         textStyle:
                    //             Theme.of(context).textTheme.displaySmall)),
                    // Text('Click here to flip front',
                    //     style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ))),
    );
  }
}

class MyProvider with ChangeNotifier {
  LanguageLabel _option = LanguageLabel.english;
  LanguageLabel _option2 = LanguageLabel.english;
  LanguageLabel get selectedLanguage => _option;
  LanguageLabel get inputLanguage => _option2;

  void test(LanguageLabel value) {
    _option = value;
    notifyListeners();
  }

  void test2(LanguageLabel val) {
    _option2 = val;
    notifyListeners();
  }
}

class InputFlag extends ChangeNotifier {
  bool _flag = false;
  bool get theFlag => _flag;

  set flagState(bool myFlag) {
    _flag = myFlag;
    notifyListeners();
  }
}

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  final TextEditingController languageController = TextEditingController();
  final TextEditingController languageController2 = TextEditingController();
  LanguageLabel? myLanguage;
  String tmp = "";
  String? value;

  @override
  Widget build(BuildContext context) {
    final option = Provider.of<MyProvider>(context, listen: false);
    // final myOption = option.selectedLanguage;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      DropdownMenu<LanguageLabel>(
        initialSelection: LanguageLabel.english,
        // initialSelection: myOption,
        // onValueChanged: (LanguageLabel newValue) {
        //   optionProvider.selectedOption = newValue;
        // },
        // initialSelection: LanguageLabel.spanish,
        controller: languageController,
        requestFocusOnTap: false,
        label: const Text('Language'),
        onSelected: (LanguageLabel? language) {
          setState(() {
            option.test(language!);
          });
        },
        // onSelected: (LanguageLabel? language) {
        //   setState(() {
        //     myLanguage = language;
        //     value = myLanguage!.label;
        //   });
        //   print(myLanguage!.label);
        // },
        dropdownMenuEntries: LanguageLabel.values
            .map<DropdownMenuEntry<LanguageLabel>>((LanguageLabel label) {
          return DropdownMenuEntry<LanguageLabel>(
            value: label,
            label: label.label,
            enabled: label.label != "None",
            style: MenuItemButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          );
        }).toList(),
      ),
      const SizedBox(
        width: 30,
      ),
      DropdownMenu<LanguageLabel>(
        //bug might occur due clicking on the default
        initialSelection: LanguageLabel.english,
        // initialSelection: myOption,
        controller: languageController2,
        requestFocusOnTap: false,
        label: const Text('Language'),
        onSelected: (LanguageLabel? language) {
          setState(() {
            option.test2(language!);
          });
        },
        dropdownMenuEntries: LanguageLabel.values
            .map<DropdownMenuEntry<LanguageLabel>>((LanguageLabel label) {
          return DropdownMenuEntry<LanguageLabel>(
            value: label,
            label: label.label,
            enabled: label.label != "None",
            style: MenuItemButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          );
        }).toList(),
      ),
    ]);
  } //build
}

typedef LanguageCallback = Function(String formText, String formOutput);
typedef LabelCallback = Function(String inLang, String outLang);

class MyForm extends StatefulWidget {
  // final ValueSetter<String>? inputText;
  // final ValueSetter<String>? outputText;
  final LanguageCallback? c;
  final LabelCallback? d;
  // final ValueChanged(String text) inputText;
  // final ValueChanged(String text1)? outputText;
  // const MyForm({super.key, this.inputText, this.outputText, this.c});
  const MyForm({super.key, this.c, this.d});

  @override
  MyFormState createState() {
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  final _key = GlobalKey<FormState>();
  final myController = TextEditingController();
  late String translation = "";
  late String input = "";
  // late String input = "";
  // late String output = "";
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void setTranslation(String option, String input) async {
    String getTranslation = await translate(myController.text, option, input);
    setState(() {
      translation = getTranslation;
      input = myController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final testProvider = Provider.of<MyProvider>(context, listen: false);
    final formProvider =
        Provider.of<TranslationProvider>(context, listen: false);
    final flagProvider = Provider.of<InputFlag>(context, listen: false);

    // Future<void> sendTranslation(String mytranslation) async {
    //   setState(() {
    //     output = mytranslation;
    //     input = myController.text;
    //     formProvider._inputText = input;
    //     formProvider._translatedText = output;
    //   });
    // }
    // final myTest = testProvider.selectedLanguage;

    // return Text(selectedOption != null ? selectedOption.name : 'No option selected');
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: myController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_key.currentState!.validate()) {
                      flagProvider.flagState = true;
                      FocusManager.instance.primaryFocus?.unfocus();
                      //edit()->user story
                      //text wrapping
                      //Prssing done on keyboard should submit form
                      // print(testProvider._option.label);
                      // print(testProvider._option2.label);
                      // setTranslation(myTest.label, testProvider._option2.label);
                      setTranslation(testProvider._option.label,
                          testProvider._option2.label);
                      setState(() {
                        widget.c!(myController.text, translation);
                        widget.d!(testProvider._option.label,
                            testProvider._option2.label);
                        formProvider.setInput(myController.text);
                        formProvider.setTranslation(translation);
                        // if (widget.inputText != null) {
                        //   widget.inputText!(myController.text);
                        // }
                        // if (widget.outputText != null) {
                        //   widget.outputText!(translation);
                        // }
                      });
                      // print(_myKey.currentState!.myLanguage!.label);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(translation),
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> translate(String mytext, String option, String output) async {
  final gt = SimplyTranslator(EngineType.google);
  // String textResult = await gt.trSimply(mytext, "en", "de");
  String textResult = await gt.trSimply(mytext, option, output);
  // print(textResult);
  // String textResult = await gt.trSimply("Er läuft schnell.", "de", 'en');
  return textResult;
  //using Googletranslate:
}

// ignore: must_be_immutable
class Addnotecard extends StatefulWidget {
  late String inputtext;
  late String outputtext;
  late String inputLang;
  late String outputLang;
  Addnotecard(
      {super.key,
      required this.inputtext,
      required this.outputtext,
      required this.inputLang,
      required this.outputLang});

  @override
  State<Addnotecard> createState() => _AddnotecardState();
}

class _AddnotecardState extends State<Addnotecard> {
  List<Notecard> list = [];
  void addNoteCard() {
    setState(() {
      list.add(Notecard(
        input: widget.inputtext,
        output: widget.outputtext,
        inLang: widget.inputLang,
        outLang: widget.outputLang,
      ));
    });
  }

  void removeNoteCard() {
    setState(() {
      list.remove(list.last);
      // list.remove(Notecard(input: input, output: output));
    });
  }

  Future<DocumentReference> storeNotes(
      bool flag, String text1, String text2, String text3, String text4) {
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
      throw Exception('Must have text');
    }

    if (kDebugMode) {
      print(FirebaseAuth.instance.currentUser!.email);
    }

    if (list.isEmpty) {
      throw Exception("Notecard list is empty");
    }

    //Note, need to consider list of notecards, only save current notecard

    return FirebaseFirestore.instance
        .collection("translation_notecards")
        .add(<String, dynamic>{
      'input_text': text1,
      'output_text': text2,
      'inLang': text3,
      'outLang': text4,
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InputFlag>(context, listen: true);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (provider.theFlag) {
                  if (kDebugMode) {
                    print(provider.theFlag);
                  }
                  addNoteCard();
                } else {
                  if (kDebugMode) {
                    print(provider.theFlag);
                  }
                  final snackBar = SnackBar(
                    content: const Text('Do not have current translation'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                    duration: const Duration(milliseconds: 600),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                // print(list.length);
              },
              child: const Text("Add notecard"),
            ),
            const SizedBox(
              width: 10,
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
                child: const Text("Remove notecard")),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  storeNotes(provider.theFlag, widget.inputtext,
                      widget.outputtext, widget.inputLang, widget.outputLang);
                },
                child: const Text("Save Notecard")),
          ],
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return list[index];
            }),
      ],
    );
  }
}

class Translatepage extends StatefulWidget {
  // final Function(String text)? inputText;
  // final Function(String text1)? outputText;
  // final List<Notecard> list;
  const Translatepage({
    super.key,
    // this.inputText,
    // this.outputText,
    // this.list = const [],
  });

  @override
  State<Translatepage> createState() => _TranslatepageState();
}

class _TranslatepageState extends State<Translatepage> {
  String input = "";
  String output = "";
  String inLabel = "";
  String outLabel = "";
  String setInput(String inp) {
    setState(() {
      input = inp;
    });
    return input;
  }

  String setOutput(String out) {
    setState(() {
      output = out;
    });
    return output;
  }

  String setInpLang(String firstLabel) {
    setState(() {
      inLabel = firstLabel;
    });
    return inLabel;
  }

  String setOutLang(String translationLabel) {
    setState(() {
      outLabel = translationLabel;
    });
    return outLabel;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyProvider()),
        // ChangeNotifierProxyProvider<MyProvider, TranslationProvider>(
        //   create: (context) => TranslationProvider(),
        //   update: (_, myModel, myNotifier) => myNotifier!..update(myModel),
        // )
        ChangeNotifierProvider(create: (context) => TranslationProvider()),
        ChangeNotifierProvider(create: (context) => InputFlag())
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        //when tapping on screen outside form, it dismisses keyboard
        child: Scaffold(
            // appBar: AppBar(
            //     centerTitle: true,
            //     title: const Text(
            //       "Language Learner",
            //       style: TextStyle(
            //           color: Colors.white, fontWeight: FontWeight.bold),
            //     )),
            body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(children: [
            // ElevatedButton(
            //   child: const Text("Go back"),
            //   onPressed: () {
            //     // translate();
            //     Navigator.pop(context);
            //   },
            // ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Enter a text to translate.",
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            MyForm(
              c: (formText, formOutput) {
                input = setInput(formText);
                output = setOutput(formOutput);
                // input = formOutput;
                // output = formText;
              },

              d: (inLang, outLang) {
                inLabel = setInpLang(inLang);
                outLabel = setOutLang(outLang);
              },
              // inputText: updateInput,
              // outputText: updateOutput,
            ),
            const Dropdown(),
            const SizedBox(
              height: 20,
            ),
            Addnotecard(
              inputtext: input,
              outputtext: output,
              inputLang: inLabel,
              outputLang: outLabel,
            ),
          ]),
        )),
      ),
      //),
    );
  }
}

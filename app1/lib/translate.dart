import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplytranslate/simplytranslate.dart';

enum LanguageLabel {
  spanish("es"),
  english("en"),
  german("de"),
  italian("it"),
  persian("fa"),
  turkish("tr"),
  japanese("ja");

  const LanguageLabel(this.label);
  final String label;
}

class TranslationProvider with ChangeNotifier {
  String _inputText = "";
  String _translatedText = "";
  String get input => _inputText;
  String get output => _translatedText;

  void update(MyProvider myModel) {
    // Do some custom work based on myModel that may call `notifyListeners`
  }

  void setInput(String value) {
    _inputText = value;
    notifyListeners();
  }

  void setTranslation(String val) {
    _translatedText = val;
    notifyListeners();
  }
}

class Notecard extends StatelessWidget {
  const Notecard({super.key});
//Listview to display cards
  @override
  Widget build(BuildContext context) {
    final testProvider = Provider.of<MyProvider>(context, listen: true);
    final language = Provider.of<TranslationProvider>(context, listen: true);
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
              speed: 1000,
              front: Expanded(
                // width: 300,
                // height: 120,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 223, 247),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          "From: ${testProvider._option.label} => ${language._inputText}",
                          // Text("hello",
                          style: Theme.of(context).textTheme.displaySmall),
                      // Text(testProvider._option2.label,
                      //     style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
              back: Expanded(
                // width: 300,
                // height: 120,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 223, 247),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Text("Hi",
                      Text(
                          "To: ${testProvider._option2.label} => ${language._translatedText}",
                          style: Theme.of(context).textTheme.displaySmall),
                      // Text('Click here to flip front',
                      //     style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
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

class MyForm extends StatefulWidget {
  const MyForm({super.key});

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
                        formProvider.setInput(myController.text);
                        formProvider.setTranslation(translation);
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

// List<Notecard> list = [];

class Translatepage extends StatelessWidget {
  const Translatepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyProvider()),
        // ChangeNotifierProxyProvider<MyProvider, TranslationProvider>(
        //   create: (context) => TranslationProvider(),
        //   update: (_, myModel, myNotifier) => myNotifier!..update(myModel),
        // )
        ChangeNotifierProvider(create: (context) => TranslationProvider())
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        //when tapping on screen outside form, it dismisses keyboard
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "Language Learner",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            body: SingleChildScrollView(
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
                const MyForm(),
                const Dropdown(),
                const Notecard(),
                // const Notecard(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () {
                          // list.add(const Notecard());
                          // print(list.length);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const Notecard()));
                          // const Notecard();
                        },
                        child: const Text("Create Notecard")),
                  ),
                ),
              ]),
            )),
      ),
      //),
    );
  }
}

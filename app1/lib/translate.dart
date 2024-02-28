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
    final myOption = option.selectedLanguage;
    return Row(children: [
      DropdownMenu<LanguageLabel>(
        initialSelection: myOption,
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
        initialSelection: myOption,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final testProvider = Provider.of<MyProvider>(context, listen: false);
    final myTest = testProvider.selectedLanguage;

    // return Text(selectedOption != null ? selectedOption.name : 'No option selected');
    return Form(
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
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_key.currentState!.validate()) {
                // print(testProvider._option.label);
                // print(testProvider._option2.label);
                // setTranslation(myTest.label, testProvider._option2.label);
                setTranslation(
                    testProvider._option.label, testProvider._option2.label);
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
        ],
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

class Translatepage extends StatelessWidget {
  const Translatepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: Scaffold(
          appBar: AppBar(title: const Text("Language Learner")),
          body: Center(
              child: Column(children: [
            ElevatedButton(
              child: const Text("Go back"),
              onPressed: () {
                // translate();
                Navigator.pop(context);
              },
            ),
            const MyForm(),
            const Dropdown(),
            // const SizedBox(height: 20),
            // const Dropdown(),
          ]))),
    );
  }
}

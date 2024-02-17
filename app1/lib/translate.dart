import 'package:flutter/material.dart';
import 'package:simplytranslate/simplytranslate.dart';

enum LanguageLabel {
  spanish("es"),
  english("en"),
  german("de"),
  italian("it");

  const LanguageLabel(this.label);
  final String label;
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                showDialog(
                  context: context,
                  builder: (context) {
                    // Retrieve the text that the user has entered by using the
                    // TextEditingController.
                    return AlertDialog(
                      content: Text(myController.text),
                      // content: Text(translate(myController.text) as String),
                      // String mytext = translate(myController.text);
                      // content: Text(text),
                      // content: translate(myController.text),
                    );
                    // return AlertDialog(
                    //   content: Text(myController.text),
                    // );
                  },
                );
                // translate();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Processing Data')),
                // );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// Future<void> translate(String mytext) async {
Future<String> translate(String mytext) async {
  final gt = SimplyTranslator(EngineType.google);
  String textResult = await gt.trSimply(mytext, "de", "en");
  // String textResult = await gt.trSimply("Er läuft schnell.", "de", 'en');
  // Text(textResult);
  return textResult;
  //He walks fast.
  //using Googletranslate:
  //short form to only get translated text as String, also shorter code:
}

class Translatepage extends StatelessWidget {
  const Translatepage({super.key});
  // final VoidCallback addUser; // ==> Here is the answer.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ])));
  }
}

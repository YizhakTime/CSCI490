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
  late String translation = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void setTranslation() async {
    String firstTranslation = await translate(myController.text);

    setState(() {
      translation = firstTranslation;
    });
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
                setTranslation();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(translation),
                    );
                  },
                );
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

Future<String> translate(String mytext) async {
  final gt = SimplyTranslator(EngineType.google);
  String textResult = await gt.trSimply(mytext, "en", "de");
  // String textResult = await gt.trSimply("Er läuft schnell.", "de", 'en');
  return textResult;
  //using Googletranslate:
}

class Translatepage extends StatelessWidget {
  const Translatepage({super.key});

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

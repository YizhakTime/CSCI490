import 'package:app1/auth_page.dart';
import 'package:app1/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:translator/translator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final translator = GoogleTranslator();
  const input = "Здравствуйте. Ты в порядке?";
  translator.translate(input, from: 'ru', to: 'en').then(print);
  // prints Hello. Are you okay?
  Translation translation =
      await translator.translate("Dart is very cool!", to: 'pl');
  print(translation);
  // prints Dart jest bardzo fajny!
  print(await "example".translate(to: 'pt'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //flutter run
        //Hot reload = r, state is not lost during reload
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Mywrapper(),
    );
  }
}

// return MaterialApp(
//   title: 'Flutter Demo',
//   theme: ThemeData(
//     //flutter run
//     //Hot reload = r, state is not lost during reload
//     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//     useMaterial3: true,
//   ),
//   home: const Mywrapper(),

// const MyHomePage(title: 'Welcome to LanguageLearner'),

class Mywrapper extends StatelessWidget {
  const Mywrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Authenticate();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  //Future is an async operation which means result will be ready in future
  //When another fxn calls it, it should wait until Future fxn is ready to return
  //(i.e. it should use the await keyword)
  //This should be in the camera page
  /*
  1. Add async to function body 
  - void test() async {}
  2. If fxn returns a type, update type to be Future<T>, where T is type fxn returns
  - Else, if fxn doesn't return a type, then return type is Future<void>
  Future<void> main() async {}
  3. Use await keyword to wait for future to complete 
  - print(await createOrderMessage());
*/
  // Future<http.Response> getTranslationApi() {
  //   return http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos/1"));
  // }

/*
Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}
*/

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

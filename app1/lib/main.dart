// import 'package:app1/auth_page.dart';
import 'dart:ui';
import 'package:app1/check_auth.dart';
// import 'package:app1/home.dart';
// import 'package:app1/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
import 'firebase_options.dart';
// import 'package:translator/translator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final translator = GoogleTranslator();
  // const input = "Здравствуйте. Ты в порядке?";
  // translator.translate(input, from: 'ru', to: 'en').then(print);
  // // prints Hello. Are you okay?
  // Translation translation =
  //     await translator.translate("Dart is very cool!", to: 'pl');
  // print(translation);
  // // prints Dart jest bardzo fajny!
  // print(await "example".translate(to: 'pt'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CheckAuthState(),
    );
  }
}

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

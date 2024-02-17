// import 'package:firebase_auth/firebase_auth.dart';

// class AuthLogic {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   // final FirebaseAuth _firebaseAuth;
//   // AuthLogic(this._firebaseAuth);
//   //underscore equals private

//   // Stream<User?> get authStateChanges => _auth.authStateChanges();

//   Future loginAnon() async {
//     try {
//       UserCredential result = await _auth.signInAnonymously();
//       User? anonUser = result.user;
//       print("Signed in with temporary account.");
//       return anonUser;
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case "operation-not-allowed":
//           print(e.toString());
//           print("Anonymous auth hasn't been enabled for this project.");
//           break;
//         default:
//           print(e.toString());
//           print("Unknown error.");
//           return null;
//       }
//     }
//   }

//   Future<String> login(String emailAddress, String password) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//           email: emailAddress, password: password);
//       return "Signed-in";
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       }
//       return e.toString();
//     }
//   }

//   Future<String> signUp(String email, String password) async {
//     try {
//       UserCredential credential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return "Signing-in";
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//       return e.toString();
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   // FirebaseAuth.instance.authStateChanges().listen((User? user) {
//   //   if (user == null) {
//   //     print('User is currently signed out!');
//   //   } else {
//   //     print('User is signed in!');
//   //   }
//   // });
// }

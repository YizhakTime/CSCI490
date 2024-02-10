import 'package:app1/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase;
// import 'package:firebase_auth_platform_interface/src/auth_provider.dart';

class CheckAuthState extends StatelessWidget {
  const CheckAuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
          );
        } //No data
        return Home(user: snapshot.data);
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pndd/screens/home_screen.dart';
import 'package:pndd/screens/login_screen.dart';

class AuthStateNotifier extends StatelessWidget {
  const AuthStateNotifier({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        });
  }
}

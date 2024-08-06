import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> register(
      {required String email, required String password}) async {
    try {
      final cred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred;
    } catch (e) {
      rethrow;
    }
  }
}

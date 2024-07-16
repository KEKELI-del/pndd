// ignore_for_file: depend_on_referenced_packages, use_rethrow_when_possible

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService with ChangeNotifier {
  String? _token;
  String? _userId;

  String? get token {
    return _token;
  }

  bool get isAuth {
    return token != null;
  }

  Future<bool> _authenticate(String email, String password, String urlSegment) async {
    final url = Uri.parse('http://<your-backend-url>/$urlSegment');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _token = responseData['token'];
        _userId = responseData['userId'];
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
        });
        prefs.setString('userData', userData);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    return _authenticate(email, password, 'login');
  }

  Future<bool> register(String email, String password) async {
    return _authenticate(email, password, 'register');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    notifyListeners();
    return true;
  }
}

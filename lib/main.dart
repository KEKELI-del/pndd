// main.dart
// ignore_for_file: unused_import, camel_case_types, duplicate_import

import 'package:flutter/material.dart';
import 'package:pndd/screens/home_screen.dart';
import 'package:pndd/screens/signup_screen.dart';
import 'package:pndd/screens/upload_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/upload_screen.dart'; 
import 'screens/result_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant Nutrient Detector',
        theme: ThemeData(
          primarySwatch: Colors.green,
        
        ),
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/upload': (context) => const UploadScreen(),
          '/result': (context) => const ResultsScreen(result: '',),
          '/signup':(context) => const SignUpScreen(),
        },
      ),
    );
  }
}






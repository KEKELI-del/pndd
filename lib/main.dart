// main.dart
// ignore_for_file: unused_import, camel_case_types, 
import 'package:firebase_core/firebase_core.dart';
import 'package:pndd/screens/auth_state_notifier.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pndd/screens/home_screen.dart';
import 'package:pndd/screens/login_screen.dart';
import 'package:pndd/screens/result_screen.dart';
import 'package:pndd/screens/signup_screen.dart';
import 'package:pndd/screens/upload_screen.dart';
import 'package:pndd/services/auth_service.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          primaryColor: const Color.fromARGB(255, 56, 142, 60)
        ),
        home: const AuthStateNotifier(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/upload': (context) => const UploadScreen(image: null,),
          '/result': (context) => const ResultsScreen(diseaseName: ''),
          '/signup': (context) => const SignUpScreen(),
        },
      ),
    );
  }
}





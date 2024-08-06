// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final bool _isLoading = false;
  final String _result = '';

  Future<void> _showPicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _imgFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _navigateToUploadScreen();
      }
    });
  }

  _imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _navigateToUploadScreen();
      }
    });
  }

  void _navigateToUploadScreen() {
    if (_image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadScreen(image: _image!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Plant Nutrient Deficiency Detector"),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.23,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                  ),
                  color: primaryColor,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Plant Nutrient Deficiency Detector',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeScreenButton(
                    title: 'Sign Up',
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    color: primaryColor,
                  ),
                  const SizedBox(height: 10),
                  HomeScreenButton(
                    title: 'Upload Image',
                    onPressed: () {
                      _showPicker(context);
                    },
                    color: primaryColor,
                  ),
                  const SizedBox(height: 10),
                  HomeScreenButton(
                    title: 'View Results',
                    onPressed: () {
                      Navigator.pushNamed(context, '/result');
                    },
                    color: primaryColor,
                  ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        )
                      : Text(
                          _result, // Display the result from the model
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeScreenIconButton(
                        icon: Icons.info,
                        onPressed: () {
                          // Handle action for info button
                        },
                        color: primaryColor,
                      ),
                      HomeScreenIconButton(
                        icon: Icons.settings,
                        onPressed: () {
                          // Handle action for settings button
                        },
                        color: primaryColor,
                      ),
                      HomeScreenIconButton(
                        icon: Icons.notifications,
                        onPressed: () {
                          // Handle action for notifications button
                        },
                        color: primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;

  const HomeScreenButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class HomeScreenIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const HomeScreenIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
        size: 32,
      ),
    );
  }
}

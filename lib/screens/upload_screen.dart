// ignore_for_file: avoid_print

import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pndd/global_methods.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pndd/screens/result_screen.dart';

class UploadScreen extends StatefulWidget {
  final File? image;

  const UploadScreen({super.key, required this.image});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  final storage = FirebaseStorage.instance;
  final currentFarmer = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.image;
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        if (mounted) {
          showSnackBar(context, "Choose an image file");
        }
      }
    });
  }

  Future<void> uploadImage() async {
    if (_selectedImage == null) return;
    final imageFileName = path.basename(_selectedImage!.path);

    setState(() {
      _isLoading = true;
    });
    try {
      // create reference for path to storage location for image
      final storageRef = storage
          .ref()
          .child("leaves_to_analyze/${currentFarmer!.email}/$imageFileName");

      // upload to firebase storage
      storageRef.putFile(_selectedImage!);

      if (mounted) {
        // show success message
        showSnackBar(context, "Image uploaded successfully!");

        // navigate to results page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultsScreen(diseaseName: "kooko"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      body: SingleChildScrollView(
        child: Column(
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
                      'Upload Image',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_selectedImage != null) Image.file(_selectedImage!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Pick Image from Gallery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Take a Photo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedImage != null && !_isLoading)
                    HomeScreenButton(
                      title: 'Upload Image',
                      onPressed: uploadImage,
                      color: primaryColor,
                    ),
                  if (_isLoading)
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
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

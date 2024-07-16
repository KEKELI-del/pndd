// screens/upload_screen.dart
// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, depend_on_referenced_packages, library_private_types_in_public_api, unused_local_variable, avoid_print, prefer_typing_uninitialized_variables, unnecessary_null_comparison, unused_field, unused_import, duplicate_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedImage;
  bool detecting = false;
  String diseaseName = '';
  bool precautionLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> detectDisease() async {
    if (_selectedImage == null) return;

    setState(() {
      detecting = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.10:5000/upload'), // backend URL
    );
    request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
    request.headers['Authorization'] = 'Bearer ${authService.token}';
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      setState(() {
        diseaseName = responseData.body; // Assuming the response body contains the disease name
        detecting = false;
      });
    } else {
      print('Detection failed');
      setState(() {
        detecting = false;
      });
    }
  }

  Future<void> showPrecautions() async {
    setState(() {
      precautionLoading = true;
    });


    setState(() {
      precautionLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.green.shade700;

    return Scaffold(
      body: Column(
        children: <Widget>[
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
                  color: Colors.blue, // Replace with your theme color
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Replace with your theme color
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'OPEN GALLERY',
                            style: TextStyle(color: Colors.white), // Replace with your text color
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.image,
                            color: Colors.white, // Replace with your text color
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Replace with your theme color
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'START CAMERA',
                            style: TextStyle(color: Colors.white), // Replace with your text color
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white, // Replace with your text color
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _selectedImage == null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.asset('assets/wallpaper.jpg'),
                )
              : Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
          if (_selectedImage != null)
            detecting
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor), // Replace with your theme color
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Replace with your theme color
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        detectDisease();
                      },
                      child: const Text(
                        'DETECT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          if (diseaseName.isNotEmpty)
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        diseaseName.trim(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                precautionLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor), // Replace with your theme color
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          showPrecautions();
                        },
                        child: const Text(
                          'PRECAUTION',
                          style: TextStyle(
                            color: Colors.white, // Replace with your text color
                          ),
                        ),
                      ),
              ],
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

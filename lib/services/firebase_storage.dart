


import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final _storage = FirebaseStorage.instance;

  Future<void> uploadFile(String path, File file) async {
    try {
      await _storage.ref(path).putFile(file);
    } catch (e) {
      ('Error uploading file: $e');
    }
  }
}



// ignore_for_file: empty_catches

import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

Future<void> initializeData() async {
  try {
    
  } catch (e) {
    
  }
}

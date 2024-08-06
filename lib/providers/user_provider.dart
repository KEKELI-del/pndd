import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _farmerData = {};

  get farmerData => _farmerData;

  set farmerData(data) {
    _farmerData = data;
    notifyListeners();
  }
}
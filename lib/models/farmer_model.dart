import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerModel {
  FarmerModel({
    required this.email,
    required this.username,
    required this.uid,
  });

  final String username;
  final String email;
  final String uid;

  factory FarmerModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return FarmerModel(
      email: data?["email"] ?? "no-email@gmail.com",
      username: data?["username"],
      uid: data?["uid"],
    );
  }

  Map<String, dynamic> toMap() => {
    "username": username,
    "email": email,
    "uid": uid,
  };
}

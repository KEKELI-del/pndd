import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pndd/models/farmer_model.dart';

final store = FirebaseFirestore.instance;

  // create farmer document
  Future<void> createFarmerDoc(FarmerModel farmerModel) async {
    try {
      await store
          .collection("Farmers")
          .doc(farmerModel.email)
          .set(farmerModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // get current farmer's data from firestore
  Future<void> getFarmerData() async {
    // ignore: unused_local_variable
    final currentFarmer = FirebaseAuth.instance.currentUser!.uid;
  }

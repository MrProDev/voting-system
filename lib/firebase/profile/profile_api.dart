import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/models/user_data.dart';

class ProfileApi {
  String getUid() => FirebaseAuth.instance.currentUser!.uid;
  Future<UserData?> getUserData() async {
    try {
      final userdoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(getUid())
          .get();

      return UserData.fromJson(userdoc.data());
    } on PlatformException {
      return null;
    }
  }
}

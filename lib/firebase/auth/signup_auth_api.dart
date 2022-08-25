import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/models/user_data.dart';

class SignUpAuthApi {
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException {
      return null;
    }
  }

  String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<String?> uploadProfilePicture({required File image}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${getCurrentUid()}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on PlatformException {
      return null;
    }
  }

  Future createUser({
    required String name,
    required String constituency,
    required String cnic,
    required User user,
    required String imageUrl,
  }) async {
    UserData userData = UserData(
      uid: getCurrentUid(),
      name: name,
      email: user.email,
      imageUrl: imageUrl,
      constituency: constituency,
      cnic: cnic,
      userType: "user",
      hasVoted: false,
    );
    try {
      final DocumentReference<Map<String, dynamic>> doc =
          FirebaseFirestore.instance.collection('users').doc(getCurrentUid());

      await doc.set(userData.toJson());
    } on PlatformException {
      return null;
    }
  }
}

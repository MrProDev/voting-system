import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/models/user_data.dart';

class UserApi {

  Future<UserData?> getUserData({required String uid}) async {
    try {
      final userdoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      return UserData.fromJson(userdoc.data());
    } on PlatformException {
      return null;
    }
  }

  Future setUserAsCandidate({required UserData? userData}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData!.uid)
          .set(
            userData.toJson(),
          );
    } on PlatformException {
      return null;
    }
  }

  Future setUserAsApplied({required UserData? userData, required String uid}) async {
    try {
      userData!.hasApplied = true;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(
            userData.toJson(),
          );
    } on PlatformException {
      return null;
    }
  }




  Future<List<UserData>?> getUsersData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users').limit(20)
          .get();

      return snapshot.docs
          .map(
            (userDoc) => UserData.fromJson(
              userDoc.data(),
            ),
          )
          .toList();
    } on PlatformException {
      return null;
    }
  }
}
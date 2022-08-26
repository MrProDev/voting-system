import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/user_data.dart';

class UserApi {
  String getCurrentUid() => FirebaseAuth.instance.currentUser!.uid;

  Future<String?> getConstituency() async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUid())
          .get()
          .then(
            (value) => value.data()?['constituency'],
          );
    } on PlatformException {
      return null;
    }
  }

  Future<String?> getUserType() async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUid())
          .get()
          .then(
            (value) => value.data()?['userType'],
          );
    } on PlatformException {
      return null;
    }
  }

  Future<UserData?> getUserData() async {
    try {
      final userdoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUid())
          .get();

      return UserData.fromJson(userdoc.data());
    } on PlatformException {
      return null;
    }
  }

  Future setUserData({required UserData? userData}) async {
    try {
      userData!.userType = 'candidate';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUid())
          .set(
            userData.toJson(),
          );
    } on PlatformException {
      return null;
    }
  }

  Future<List<UserData>?> getShowUsersData({required BuildContext context}) async {
    try {
      final commonApi = Provider.of<UserApi>(context, listen: false);
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'constituency',
            isEqualTo: await commonApi.getConstituency(),
          ).limit(20)
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

  Future<List<UserData>?> getUsersData({required BuildContext context }) async {
    try {
      final commonApi = Provider.of<UserApi>(context, listen: false);
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'constituency',
            isEqualTo: await commonApi.getConstituency(),
          )
          .where(
            'userType',
            isEqualTo: 'candidate',
          )
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
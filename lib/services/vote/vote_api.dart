import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/services/users/user_api.dart';
import 'package:voting_system/models/user_data.dart';

class VoteApi {
  String getCurrentUid() => FirebaseAuth.instance.currentUser!.uid;
  Future<bool?> checkIfVoted({
    required String userUid,
  }) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get()
          .then(
            (value) => value.data()?['hasVoted'],
          );
    } on PlatformException {
      return null;
    }
  }

  Future vote({
    required String constituency,
    required String userUid,
    required String candidateUid,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('votes')
          .doc(constituency)
          .collection(candidateUid)
          .doc(userUid)
          .set({
        'userUid': userUid,
        'candidateUid': candidateUid,
      });
    } on PlatformException {
      return null;
    }
  }

  Future voteDone({
    required String userUid,
    required BuildContext context,
  }) async {
    try {
      final commonApi = Provider.of<UserApi>(context, listen: false);

      UserData? userData = await commonApi.getUserData();

      userData!.hasVoted = true;

      await commonApi.setUserData(userData: userData);
    } on PlatformException {
      return null;
    }
  }
}

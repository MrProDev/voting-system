import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/models/user_data.dart';

class VoteApi {
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
  }) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();

      UserData userData = UserData.fromJson(doc.data());

      userData.hasVoted = true;

      await FirebaseFirestore.instance.collection('users').doc(userUid).set(
            userData.toJson(),
          );
    } on PlatformException {
      return null;
    }
  }
}

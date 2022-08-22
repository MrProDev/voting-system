import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';

class ApplyCandidateApi {
  Future applyForCandidate(
      {required String partyName, required File image}) async {
    final userdoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUid())
        .get();

    UserData userData = UserData.fromJson(userdoc.data());

    userData.userType = 'candidate';

    String? constituency = userData.constituency;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUid())
        .set(
          userData.toJson(),
        );

    String? imageUrl = await uploadPartyImage(image: image);

    CandidateData candidateData = CandidateData(
      uid: getCurrentUid(),
      partyName: partyName,
      imageUrl: imageUrl,
      constituency: constituency,
    );

    try {
      final doc = FirebaseFirestore.instance
          .collection('candidates')
          .doc(getCurrentUid());
      await doc.set(candidateData.toJson());
    } on PlatformException {
      return null;
    }
  }

  String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<String?> uploadPartyImage({required File image}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('candidate_party_images')
          .child('${getCurrentUid()}_party.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on PlatformException {
      return null;
    }
  }

  Future getConstituency() async {
    try {
      return await FirebaseFirestore.instance
          .collection('candidates')
          .doc(getCurrentUid())
          .get()
          .then(
            (value) => value.data()?['constituency'],
          );
    } on PlatformException {
      return null;
    }
  }
}

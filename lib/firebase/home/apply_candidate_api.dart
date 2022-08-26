import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';

class ApplyCandidateApi {
  String getCurrentUid() => FirebaseAuth.instance.currentUser!.uid;

  Future applyForCandidate({
    required String partyName,
    required File image,
    required BuildContext context,
  }) async {
    final userApi = Provider.of<UserApi>(context, listen: false);
    UserData? userData = await userApi.getUserData();

    await userApi.setUserData(userData: userData);

    String? imageUrl = await uploadPartyImage(image: image);
    String? constituency = userData!.constituency;

    CandidateData candidateData = CandidateData(
      uid: getCurrentUid(),
      partyName: partyName,
      imageUrl: imageUrl,
      isApproved: false,
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

  Future checkIfCandidateExists() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(getCurrentUid())
          .get();

      return doc.exists;
    } on PlatformException {
      return null;
    }
  }
}

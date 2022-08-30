import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/services/users/user_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';

class ApplyCandidateApi {

  Future applyForCandidate({
    required String partyName,
    required File image,
    required BuildContext context,
    required String uid,
  }) async {
    final userApi = Provider.of<UserApi>(context, listen: false);
    UserData? userData = await userApi.getUserData(uid: uid);

    await userApi.setUserAsApplied(userData: userData, uid: uid);

    String? imageUrl = await uploadPartyImage(image: image, uid: uid);
    String? constituency = userData!.constituency;

    CandidateData candidateData = CandidateData(
      uid: uid,
      partyName: partyName,
      imageUrl: imageUrl,
      isApproved: false,
      constituency: constituency,
    );

    try {
      final doc = FirebaseFirestore.instance
          .collection('candidates')
          .doc(uid);
      await doc.set(candidateData.toJson());
    } on PlatformException {
      return null;
    }
  }

  Future<String?> uploadPartyImage({required File image, required String uid}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('candidate_party_images')
          .child('${uid}_party.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on PlatformException {
      return null;
    }
  }

  Future checkIfCandidateExists({required String uid}) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(uid)
          .get();

      return doc.exists;
    } on PlatformException {
      return null;
    }
  }
}

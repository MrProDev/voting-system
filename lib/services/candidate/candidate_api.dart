import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/models/candidate_data.dart';

class CandidateApi {
  String getCurrentUid() => FirebaseAuth.instance.currentUser!.uid;
  Future<CandidateData?> getCandidateData() async {
    try {
      final candidateDoc = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(getCurrentUid())
          .get();

      return CandidateData.fromJson(candidateDoc.data());
    } on PlatformException {
      return null;
    }
  }

  Future setCandidateAsApproved({required CandidateData candidateData}) async {
    try {

      if (candidateData.isApproved == true) {
        candidateData.isApproved = false;
      } else if (candidateData.isApproved == false) {
        candidateData.isApproved = true;
      }

      await FirebaseFirestore.instance
          .collection('candidates')
          .doc(candidateData.uid)
          .set(candidateData.toJson());
    } on PlatformException {
      return null;
    }
  }
}

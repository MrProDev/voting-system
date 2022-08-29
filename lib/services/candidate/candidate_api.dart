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

  Future<bool?> checkIfApproved() async {
    try {
      return await FirebaseFirestore.instance
          .collection('candidates')
          .doc(getCurrentUid())
          .get()
          .then((value) => value.data()!['isApproved']);
    } on PlatformException {
      return null;
    }
  }

  Future<List<CandidateData>?> getPendingCandidatesData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('candidates')
          .limit(20)
          .get();

      return snapshot.docs
          .map(
            (candidateDoc) => CandidateData.fromJson(
              candidateDoc.data(),
            ),
          )
          .toList();
    } on PlatformException {
      return null;
    }
  }

  Future<List<CandidateData>?> getCandidatesData(
      {required String constituency}) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('candidates')
          .where(
            'constituency',
            isEqualTo: constituency,
          )
          .limit(20)
          .get();

      return snapshot.docs
          .map(
            (candidateDoc) => CandidateData.fromJson(
              candidateDoc.data(),
            ),
          )
          .toList();
    } on PlatformException {
      return null;
    }
  }

  Future<CandidateData?> getPendingCandidateData({required String uid}) async {
    try {
      final candidateDoc = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(uid)
          .get();

      return CandidateData.fromJson(candidateDoc.data());
    } on PlatformException {
      return null;
    }
  }

  Future setCandidateAsApproved({required String uid}) async {
    try {
      CandidateData? candidateData = await getPendingCandidateData(uid: uid);

      if (candidateData!.isApproved == true) {
        candidateData.isApproved = false;
      } else if (candidateData.isApproved == false) {
        candidateData.isApproved = true;
      }

      await FirebaseFirestore.instance
          .collection('candidates')
          .doc(uid)
          .set(candidateData.toJson());
    } on PlatformException {
      return null;
    }
  }
}

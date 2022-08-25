import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/models/candidate_data.dart';

class CandidateApi{
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

  Future<List<CandidateData>?> getCandidatesData({required BuildContext context}) async {
    try {
      final commonApi = Provider.of<UserApi>(context, listen: false);
      final snapshot = await FirebaseFirestore.instance
          .collection('candidates')
          .where(
            'constituency',
            isEqualTo: await commonApi.getConstituency(),
          )
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
}
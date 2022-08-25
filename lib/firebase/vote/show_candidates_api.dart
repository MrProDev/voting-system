import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';

class ShowCandidatesApi {
  String getUid() => FirebaseAuth.instance.currentUser!.uid;

  Future<List<UserData>?> getUsersData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'constituency',
            isEqualTo: await getConstituency(),
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

  Future<String?> getConstituency() async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(getUid())
          .get()
          .then(
            (value) => value.data()?['constituency'],
          );
    } on PlatformException {
      return null;
    }
  }

  Future<List<CandidateData>?> getCandidatesData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('candidates')
          .where(
            'constituency',
            isEqualTo: await getConstituency(),
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

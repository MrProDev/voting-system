import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/services/users/user_api.dart';

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

  Future setCandidateAsApproved(
      {required BuildContext context,
      required CandidateData candidateData,
      required String uid}) async {
    try {
      final userApi = Provider.of<UserApi>(context, listen: false);
      UserData? userData = await userApi.getUserData(uid: uid);
      if (candidateData.isApproved == true) {
        candidateData.isApproved = false;
        userData!.userType = 'user';
      } else if (candidateData.isApproved == false) {
        candidateData.isApproved = true;
        userData!.userType = 'candidate';
      }
      await userApi.setUserAsCandidate(userData: userData);

      await FirebaseFirestore.instance
          .collection('candidates')
          .doc(candidateData.uid)
          .set(candidateData.toJson());
    } on PlatformException {
      return null;
    }
  }
}

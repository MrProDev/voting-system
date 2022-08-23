import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_system/models/candidate_data.dart';

class ShowUsersApi {
  String getUid() => FirebaseAuth.instance.currentUser!.uid;

  Future checkIfApproved() async {
    final candidateDoc = await FirebaseFirestore.instance
        .collection('candidates')
        .doc(getUid())
        .get();

    CandidateData candidateData = CandidateData.fromJson(candidateDoc.data());

    return candidateData.isApproved;
  }
}

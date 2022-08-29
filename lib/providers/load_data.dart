import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/candidate_provider.dart';
import 'package:voting_system/providers/countdown_provider.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/services/candidate/candidate_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';

class LoadData {
  String? userType = 'candidate';
  UserData? userData;
  CandidateData? candidateData;
  bool? isApproved;
  
  List<CandidateData>? pendingCandidatesData;

  loadData(BuildContext context) async {
    final countdownProvider =
        Provider.of<CountdownProvider>(context, listen: false);
    final candidateApi = Provider.of<CandidateApi>(context, listen: false);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final candidatesProvider =
        Provider.of<CandidateProvider>(context, listen: false);
    await countdownProvider.setDuration(context: context);
    await usersProvider.getUsers(context: context);
    await usersProvider.getCurrentUser(context: context);
    await candidatesProvider.getCurrentCandidate(context: context);
    if (userType == 'admin') {
      pendingCandidatesData = await candidateApi.getPendingCandidatesData();
    }
    if (userType == 'candidate') {
      isApproved = await candidateApi.checkIfApproved();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/candidate/candidate_api.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/firebase/home/countdown_time_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';

class LoadData {
  String? userType;
  Duration? duration;
  UserData? userData;
  CandidateData? candidateData;

  List<UserData>? usersData;
  List<CandidateData>? candidatesData;

  loadData(BuildContext context) async {
    final userApi = Provider.of<UserApi>(context, listen: false);
    final countdownTimeApi =
        Provider.of<CountdownTimeApi>(context, listen: false);
    final candidateApi = Provider.of<CandidateApi>(context, listen: false);
    userType = await userApi.getUserType();
    duration = await countdownTimeApi.getCountdownTimer();
    if (userType == 'candidate'){

    candidateData = await candidateApi.getCandidateData();
    }
    usersData = await userApi.getUsersData(context: context);
    userData = await userApi.getUserData();
    candidatesData = await candidateApi.getCandidatesData(context: context);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/services/candidate/candidate_api.dart';

class CandidateProvider extends ChangeNotifier {


  CandidateData? _currentCandidate;

  CandidateData? get currentCandidate => _currentCandidate;


  Future getCurrentCandidate({required BuildContext context}) async {
    _currentCandidate =
        await Provider.of<CandidateApi>(context, listen: false).getCandidateData();
    notifyListeners();
  }

  String getCandidateConstituency() {
    return _currentCandidate!.constituency ?? '';
  }

}

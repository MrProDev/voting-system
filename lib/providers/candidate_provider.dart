import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/services/candidate/candidate_api.dart';

class CandidateProvider extends ChangeNotifier {
  CandidateData? _currentCandidate;

  bool? _isApproved;
  String? _constituency;

  CandidateData? get currentCandidate => _currentCandidate;
  bool? get isApproved => _isApproved;
  String? get constituency => _constituency;

  Future getCurrentCandidate({required BuildContext context}) async {
    _currentCandidate = await Provider.of<CandidateApi>(context, listen: false)
        .getCandidateData();
    _constituency = _currentCandidate!.constituency!;
    _isApproved = _currentCandidate!.isApproved!;
    notifyListeners();
  }

  void currentCandidateAsNull() {
    _currentCandidate = null;
  }
}

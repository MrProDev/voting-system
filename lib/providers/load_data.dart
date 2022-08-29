import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/candidate_provider.dart';
import 'package:voting_system/providers/countdown_provider.dart';
import 'package:voting_system/providers/users_provider.dart';

class LoadData {
  loadData(BuildContext context) async {
    final countdownProvider =
        Provider.of<CountdownProvider>(context, listen: false);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final candidatesProvider =
        Provider.of<CandidateProvider>(context, listen: false);

    await countdownProvider.setDuration(context: context);
    await usersProvider.getUsers(context: context);
    await usersProvider.getCurrentUser(context: context);
    if (usersProvider.currentUser!.userType == 'candidate') {
      await candidatesProvider.getCurrentCandidate(context: context);
    }
  }
}

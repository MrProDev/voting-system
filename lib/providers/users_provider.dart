import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/services/users/user_api.dart';

class UsersProvider extends ChangeNotifier {
  List<UserData>? _users;

  UserData? _currentUser;

  List<UserData>? get users => _users;

  List<UserData>? get pendingUsers =>
      _users!.where((user) => user.userType == 'candidate').toList();

  List<UserData>? get showUsers =>
      _users!.where((user) => user.constituency == getConstituency()).toList();

  List<UserData>? get voteUsers => _users!
      .where((user) =>
          user.constituency == getConstituency() &&
          user.userType == 'candidate')
      .toList();

  void currentUserAsNull() {
    _currentUser = null;
  }

  void usersAsNull() {
    _users = null;
  }

  UserData? get currentUser => _currentUser;

  Future getUsers({required BuildContext context}) async {
    _users = await Provider.of<UserApi>(context, listen: false).getUsersData();
    notifyListeners();
  }

  Future getCurrentUser({required BuildContext context}) async {
    _currentUser =
        await Provider.of<UserApi>(context, listen: false).getUserData(uid: FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
  }

  Future setUserData(
      {required BuildContext context, required UserData userData}) async {
    await Provider.of<UserApi>(context, listen: false)
        .setUserAsCandidate(userData: userData);
  }

  String getConstituency() {
    return _currentUser!.constituency ?? '';
  }

  String getUserType() {
    return _currentUser!.userType ?? '';
  }
}

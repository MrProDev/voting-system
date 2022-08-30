import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/services/users/user_api.dart';

class UsersProvider extends ChangeNotifier {
  List<UserData>? _users;

  UserData? _currentUser;

  String? _constituency;
  String? _userType;

  List<UserData>? get users => _users;

  List<UserData>? get pendingUsers =>
      _users!.where((user) => user.userType == 'candidate').toList();

  List<UserData>? get showUsers =>
      _users!.where((user) => user.constituency == _constituency).toList();

  List<UserData>? get voteUsers => _users!
      .where((user) =>
          user.constituency == _constituency &&
          user.userType == 'candidate')
      .toList();

  String get constituency => _constituency!;

  String get userType => _userType!;

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
    _currentUser = await Provider.of<UserApi>(context, listen: false)
        .getUserData(uid: FirebaseAuth.instance.currentUser!.uid);
    _constituency = _currentUser!.constituency!;
    _userType = _currentUser!.userType!;
    notifyListeners();
  }

  Future setUserData(
      {required BuildContext context, required UserData userData}) async {
    await Provider.of<UserApi>(context, listen: false)
        .setUserAsCandidate(userData: userData);
  }
}

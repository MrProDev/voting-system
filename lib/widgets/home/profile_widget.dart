import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/auth/login_auth_api.dart';
import 'package:voting_system/firebase/profile/profile_api.dart';
import 'package:voting_system/models/user_data.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  UserData? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    _setUserData();
    super.initState();
  }

  _setUserData() async {
    final profileApi = Provider.of<ProfileApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final userData = await profileApi.getUserData();
    setState(() {
      _userData = userData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: const CupertinoDynamicColor.withBrightness(
                    color: CupertinoColors.white,
                    darkColor: CupertinoColors.darkBackgroundGray,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          _userData!.imageUrl!,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _userData!.name!,
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupertinoColors.lightBackgroundGray,
                    ),
                    color: const CupertinoDynamicColor.withBrightness(
                      color: CupertinoColors.white,
                      darkColor: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                  child: Text(
                    _userData!.email!,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: const Text(
                    'CNIC',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupertinoColors.lightBackgroundGray,
                    ),
                    color: const CupertinoDynamicColor.withBrightness(
                      color: CupertinoColors.white,
                      darkColor: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                  child: Text(
                    _userData!.cnic!,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: const Text(
                    'Constituency',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupertinoColors.lightBackgroundGray,
                    ),
                    color: const CupertinoDynamicColor.withBrightness(
                      color: CupertinoColors.white,
                      darkColor: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                  child: Text(
                    _userData!.constituency!,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CupertinoButton.filled(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final loginAuthApi = Provider.of<LoginAuthApi>(
                        context,
                        listen: false,
                      );
                      await loginAuthApi.signOut();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          CupertinoIcons.arrow_left,
                          color: CupertinoColors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Sign out',
                          style: TextStyle(
                            color: CupertinoColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

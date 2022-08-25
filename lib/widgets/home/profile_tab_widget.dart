import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_system/firebase/auth/login_auth_api.dart';
import 'package:voting_system/firebase/candidate/candidate_api.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/providers/load_data.dart';
import 'package:voting_system/widgets/home/profile_picture_widget.dart';

class ProfileTabWidget extends StatefulWidget {
  const ProfileTabWidget({Key? key}) : super(key: key);

  @override
  State<ProfileTabWidget> createState() => _ProfileTabWidgetState();
}

class _ProfileTabWidgetState extends State<ProfileTabWidget> {
  UserData? _userData;
  CandidateData? _candidateData;
  bool _isLoading = false;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  _setData() {
    final userData = Provider.of<LoadData>(context, listen: false).userData;
    final candidateData =
        Provider.of<LoadData>(context, listen: false).candidateData;
    setState(() {
      _userData = userData;
      _candidateData = candidateData;
    });
  }

  _getUpdatedData() async {
    final profileApi = Provider.of<CandidateApi>(context, listen: false);
    final commonApi = Provider.of<UserApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final userData = await commonApi.getUserData();
    final candidateData = await profileApi.getCandidateData();
    setState(() {
      _userData = userData;
      _candidateData = candidateData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Profile'),
            automaticallyImplyTitle: true,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _getUpdatedData();
            },
          ),
          SliverFillRemaining(
            child: _isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          ProfilePictureWidget(
                                        uid: _userData!.uid!,
                                        imageUrl: _userData!.imageUrl!,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: _userData!.uid!,
                                  child: CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(
                                      _userData!.imageUrl!,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _userData!.name!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
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
                          decoration: const BoxDecoration(
                            color: CupertinoDynamicColor.withBrightness(
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
                          decoration: const BoxDecoration(
                            color: CupertinoDynamicColor.withBrightness(
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
                          decoration: const BoxDecoration(
                            color: CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.white,
                              darkColor: CupertinoColors.darkBackgroundGray,
                            ),
                          ),
                          child: Text(
                            _userData!.constituency!,
                          ),
                        ),
                        _userData!.userType! == 'candidate'
                            ? Column(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    child: const Text(
                                      'Candidateship Status',
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
                                      color: _candidateData!.isApproved!
                                          ? CupertinoColors.systemGreen
                                          : CupertinoColors.systemYellow,
                                    ),
                                    child: Text(
                                      _candidateData!.isApproved!
                                          ? 'Approved'
                                          : 'Pending',
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 50),
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

                              Provider.of<LoadData>(context, listen: false)
                                  .userType = null;
                              Provider.of<LoadData>(context, listen: false)
                                  .duration = null;
                              Provider.of<LoadData>(context, listen: false)
                                  .userData = null;
                              Provider.of<LoadData>(context, listen: false)
                                  .candidateData = null;
                              Provider.of<LoadData>(context, listen: false)
                                  .usersData = null;
                              Provider.of<LoadData>(context, listen: false)
                                  .candidatesData = null;

                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('login', false);

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
                  ),
          )
        ],
      ),
    );
  }
}

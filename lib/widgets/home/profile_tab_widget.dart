import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/auth/login_auth_api.dart';
import 'package:voting_system/firebase/candidate/candidate_api.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/providers/load_data.dart';
import 'package:voting_system/screens/home/apply_candidate_screen.dart';
import 'package:voting_system/widgets/home/profile_picture_widget.dart';

class ProfileTabWidget extends StatefulWidget {
  const ProfileTabWidget({Key? key}) : super(key: key);

  @override
  State<ProfileTabWidget> createState() => _ProfileTabWidgetState();
}

class _ProfileTabWidgetState extends State<ProfileTabWidget> {
  UserData? _userData;
  CandidateData? _candidateData;
  String? _userType;
  bool _isLoading = false;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  _setData() {
    final userType = Provider.of<LoadData>(context, listen: false).userType;
    final userData = Provider.of<LoadData>(context, listen: false).userData;
    final candidateData =
        Provider.of<LoadData>(context, listen: false).candidateData;

    setState(() {
      _userType = userType;
      _userData = userData;
      _candidateData = candidateData;
    });
  }

  _getUpdatedData() async {
    CandidateData? candidateData;
    final profileApi = Provider.of<CandidateApi>(context, listen: false);
    final userApi = Provider.of<UserApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final userType = await userApi.getUserType();
    final userData = await userApi.getUserData();
    if (_userType == 'candidate' || _userType == 'user') {
      candidateData = await profileApi.getCandidateData();
    }
    setState(() {
      _userType = userType;
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
                        _userType == 'candidate'
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
                        _userType == 'user' ||
                                _userType == 'candidate'
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: CupertinoButton.filled(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ApplyCandidateScreen.route);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Apply for candidateship',
                                        style: TextStyle(
                                          color: CupertinoColors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        CupertinoIcons.person_add_solid,
                                        color: CupertinoColors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CupertinoButton(
                            color: CupertinoColors.systemRed.withOpacity(0.7),
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
                              Provider.of<LoadData>(context, listen: false)
                                  .isApproved = null;

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

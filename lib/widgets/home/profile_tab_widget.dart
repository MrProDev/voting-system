import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/candidate_provider.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/services/auth/login_auth_api.dart';
import 'package:voting_system/screens/profile/apply_candidate_screen.dart';
import 'package:voting_system/widgets/home/profile_picture_widget.dart';

class ProfileTabWidget extends StatelessWidget {
  const ProfileTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final candidateProvider =
        Provider.of<CandidateProvider>(context, listen: false);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Profile'),
            automaticallyImplyTitle: true,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {},
          ),
          SliverFillRemaining(
            child: MediaQuery.removePadding(
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
                                builder: (context) => ProfilePictureWidget(
                                  uid: userProvider.currentUser!.uid!,
                                  imageUrl: userProvider.currentUser!.imageUrl!,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: userProvider.currentUser!.uid!,
                            child: CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                userProvider.currentUser!.imageUrl!,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userProvider.currentUser!.name!,
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
                      userProvider.currentUser!.email!,
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
                      userProvider.currentUser!.cnic!,
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
                      userProvider.currentUser!.constituency!,
                    ),
                  ),
                  userProvider.getUserType() == 'candidate'
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
                                color: candidateProvider
                                        .currentCandidate!.isApproved!
                                    ? CupertinoColors.systemGreen
                                    : CupertinoColors.systemYellow,
                              ),
                              child: Text(
                                candidateProvider.currentCandidate!.isApproved!
                                    ? 'Approved'
                                    : 'Pending',
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  userProvider.getUserType() == 'user' ||
                          userProvider.getUserType() == 'candidate'
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

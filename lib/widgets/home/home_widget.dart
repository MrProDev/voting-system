import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/home/apply_candidate_api.dart';
import 'package:voting_system/screens/home/apply_candidate_screen.dart';
import 'package:voting_system/screens/home/show_users_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            largeTitle: Text('Home'),
          ),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemPurple,
                          CupertinoColors.systemPink,
                          CupertinoColors.systemYellow,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 1,
                      onPressed: () async {
                        final applyCandidateApi =
                            Provider.of<ApplyCandidateApi>(context,
                                listen: false);
                        final constituency =
                            await applyCandidateApi.getConstituency();
                        if (!mounted) return;
                        Navigator.pushNamed(
                          context,
                          ShowUsersScreen.route,
                          arguments: [constituency],
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Show users',
                            style: TextStyle(
                              color: CupertinoColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            CupertinoIcons.person_3,
                            color: CupertinoColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemPurple,
                          CupertinoColors.systemPink,
                          CupertinoColors.systemYellow,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ApplyCandidateScreen.route);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Apply for candidate',
                            style: TextStyle(
                              color: CupertinoColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.approval,
                            color: CupertinoColors.white,
                          ),
                        ],
                      ),
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

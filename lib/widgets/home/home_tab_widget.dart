import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/countdown_provider.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/screens/home/approve_candidates_screen.dart';
import 'package:voting_system/screens/home/pick_polling_time_screen.dart';
import 'package:voting_system/screens/home/show_results_screen.dart';
import 'package:voting_system/screens/home/show_users_screen.dart';

class HomeTabWidget extends StatefulWidget {
  const HomeTabWidget({Key? key}) : super(key: key);

  @override
  State<HomeTabWidget> createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget> {
  @override
  void initState() {
    Provider.of<CountdownProvider>(context, listen: false).startTimer();
    super.initState();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget buildTimerCard({required String time, required String header}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.extraLightBackgroundGray,
              darkColor: CupertinoColors.darkBackgroundGray,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.zero,
          child: Text(
            time,
            style: const TextStyle(
              color: CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.black,
                darkColor: CupertinoColors.white,
              ),
              fontSize: 32,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          header,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: true);
    final countdownProvider =
        Provider.of<CountdownProvider>(context, listen: false);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            largeTitle: Text('Home'),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await countdownProvider.setDuration(context: context);
              await usersProvider.getCurrentUser(context: context);
              countdownProvider.timerAsNull();
              countdownProvider.startTimer();
            },
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
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Consumer<CountdownProvider>(
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            const Text(
                              'Remaining Polling Time',
                              style: TextStyle(
                                fontSize: 24,
                                color: CupertinoDynamicColor.withBrightness(
                                  color: CupertinoColors.black,
                                  darkColor: CupertinoColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildTimerCard(
                                    time: twoDigits(
                                        value.duration.inHours.remainder(60)),
                                    header: 'Hours'),
                                const SizedBox(width: 32),
                                buildTimerCard(
                                    time: twoDigits(
                                        value.duration.inMinutes.remainder(60)),
                                    header: 'Minutes'),
                                const SizedBox(width: 32),
                                buildTimerCard(
                                    time: twoDigits(
                                        value.duration.inSeconds.remainder(60)),
                                    header: 'Seconds'),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              value.warningMessage,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  usersProvider.userType == 'admin'
                      ? Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: CupertinoButton.filled(
                                padding: EdgeInsets.zero,
                                onPressed: () => Navigator.pushNamed(
                                    context, PickPollingTimeScreen.route),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Pick Polling Time',
                                      style: TextStyle(
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: CupertinoButton.filled(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ApproveCandidatesScreen.route);
                                },
                                child: const Text(
                                  'Approve Candidates',
                                  style: TextStyle(
                                    color: CupertinoColors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  usersProvider.userType == 'candidate'
                      ? Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: CupertinoButton.filled(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ShowUsersScreen.route);
                                },
                                child: const Text(
                                  'Show Users',
                                  style: TextStyle(
                                    color: CupertinoColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<CountdownProvider>(
                              builder: (context, value, child) {
                                return value.duration.inSeconds <= 0
                                    ? Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: CupertinoButton.filled(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                ShowResultsScreen.route);
                                          },
                                          child: const Text(
                                            'Show Results',
                                            style: TextStyle(
                                              color: CupertinoColors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/home/countdown_time_api.dart';
import 'package:voting_system/screens/home/apply_candidate_screen.dart';
import 'package:voting_system/screens/home/show_users_screen.dart';

class HomeTabWidget extends StatefulWidget {
  const HomeTabWidget({Key? key}) : super(key: key);

  @override
  State<HomeTabWidget> createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget> {
  Duration? _duration;
  Timer? _timer;

  bool _isLoading = false;

  @override
  void initState() {
    _getTimer();
    _startTimer();

    super.initState();
  }

  _getTimer() async {
    final countdownTimeApi =
        Provider.of<CountdownTimeApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final duration = await countdownTimeApi.getCountdownTimer();
    setState(() {
      _isLoading = false;
    });
    setState(() {
      _duration = duration;
    });
  }

  _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final seconds = _duration!.inSeconds - 1;
        setState(() {
          if (seconds < 0) {
            _timer!.cancel();
          } else {
            _duration = Duration(seconds: seconds);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  Widget _buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(_duration!.inMinutes.remainder(60));
    final seconds = twoDigits(_duration!.inSeconds.remainder(60));
    final hours = twoDigits(_duration!.inHours.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimerCard(time: hours, header: 'Hours'),
        const SizedBox(width: 32),
        buildTimerCard(time: minutes, header: 'Minutes'),
        const SizedBox(width: 32),
        buildTimerCard(time: seconds, header: 'Seconds'),
      ],
    );
  }

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
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            largeTitle: Text('Home'),
          ),
          SliverFillRemaining(
            child: _isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Column(
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
                            _buildTime(),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: CupertinoButton.filled(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pushNamed(context, ShowUsersScreen.route);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Show Users',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                CupertinoIcons.person_3_fill,
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
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: CupertinoButton.filled(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Show Candidates',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                CupertinoIcons.person_2_fill,
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
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

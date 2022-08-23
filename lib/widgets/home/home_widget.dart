import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/screens/home/apply_candidate_screen.dart';
import 'package:voting_system/screens/home/show_users_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Duration _duration = const Duration(hours: 1);
  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final seconds = _duration.inSeconds - 1;
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
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    final hours = twoDigits(_duration.inHours.remainder(60));
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
            child: Column(
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
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CupertinoButton.filled(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pushNamed(context, ApplyCandidateScreen.route);
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
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:voting_system/widgets/home/home_tab_widget.dart';
import 'package:voting_system/widgets/home/profile_tab_widget.dart';
import 'package:voting_system/widgets/home/vote_tab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.hand_thumbsup_fill),
            label: 'Vote',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomeTabWidget();
          case 1:
            return const VoteTabWidget();
          default:
            return const ProfileTabWidget();
        }
      },
    );
  }
}

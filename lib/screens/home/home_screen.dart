import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/load_data.dart';
import 'package:voting_system/widgets/home/home_tab_widget.dart';
import 'package:voting_system/widgets/home/profile_tab_widget.dart';
import 'package:voting_system/widgets/home/vote_tab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userType;

  @override
  void initState() {
    _userType = Provider.of<LoadData>(context, listen: false).userType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_userType == 'admin') {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              activeIcon: Icon(CupertinoIcons.person_fill),
              label: 'Profile',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return const HomeTabWidget();
            default:
              return const ProfileTabWidget();
          }
        },
      );
    } else {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.hand_thumbsup),
              activeIcon: Icon(CupertinoIcons.hand_thumbsup_fill),
              label: 'Vote',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              activeIcon: Icon(CupertinoIcons.person_fill),
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
}

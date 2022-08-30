import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/widgets/home/home_tab_widget.dart';
import 'package:voting_system/widgets/home/profile_tab_widget.dart';
import 'package:voting_system/widgets/home/vote_tab_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<UsersProvider>(context, listen: true).userType == 'admin') {
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

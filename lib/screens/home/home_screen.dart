import 'package:flutter/cupertino.dart';
import 'package:voting_system/widgets/home/home_widget.dart';
import 'package:voting_system/widgets/home/profile_widget.dart';
import 'package:voting_system/widgets/shader_mask_widget.dart';

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
        activeColor: CupertinoColors.systemPink,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ShaderMaskWidget(
              child: Icon(CupertinoIcons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ShaderMaskWidget(
              child: Icon(CupertinoIcons.person),
            ),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomeWidget();
          default:
            return const ProfileWidget();
        }
      },
    );
  }
}

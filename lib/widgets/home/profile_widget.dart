import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/auth/login_auth_api.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CupertinoSliverNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            largeTitle: Text('Profile'),
          )
        ],
        body: Center(
          child: Container(
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
        ),
      ),
    );
  }
}

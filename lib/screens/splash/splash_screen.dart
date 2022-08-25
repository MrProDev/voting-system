import 'package:flutter/cupertino.dart';
import 'package:voting_system/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const AuthPage()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              CupertinoIcons.hand_thumbsup_fill,
              size: 128,
            ),
            Text(
              'Pakistan Online\nVoting System',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 40,
                color: CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.black,
                  darkColor: CupertinoColors.white,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

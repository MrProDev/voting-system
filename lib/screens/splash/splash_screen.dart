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
      () {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const AuthPage()),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: Icon(
          CupertinoIcons.hand_thumbsup_fill,
          size: 128,
        ),
      ),
    );
  }
}

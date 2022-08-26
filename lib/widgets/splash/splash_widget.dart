import 'package:flutter/cupertino.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({Key? key}) : super(key: key);

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
            SizedBox(
              height: 64,
            ),
            CupertinoActivityIndicator(
              radius: 16,
            ),
          ],
        ),
      ),
    );
  }
}

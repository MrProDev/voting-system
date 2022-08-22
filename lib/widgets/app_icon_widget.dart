import 'package:flutter/cupertino.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CupertinoColors.systemPink,
              CupertinoColors.systemPurple,
              CupertinoColors.systemYellow,
            ],
          ).createShader(bounds),
          child: const Icon(
            CupertinoIcons.hand_thumbsup_fill,
            size: 128,
          ),
        ),
      ],
    );
  }
}

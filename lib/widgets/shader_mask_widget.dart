import 'package:flutter/cupertino.dart';

class ShaderMaskWidget extends StatelessWidget {
  const ShaderMaskWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          CupertinoColors.systemPurple,
          CupertinoColors.systemPink,
          CupertinoColors.systemYellow,
        ],
      ).createShader(bounds),
      child: child,
    );
  }
}

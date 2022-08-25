import 'package:flutter/cupertino.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({Key? key, required this.imageUrl, required this.uid})
      : super(key: key);

  final String uid;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Profile Picture'),
        previousPageTitle: 'Profile',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Done'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Center(
        child: SizedBox(
          height: 500,
          width: double.infinity,
          child: Hero(
            tag: uid,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

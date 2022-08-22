import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersWidget extends StatelessWidget {
  const UsersWidget({
    Key? key,
    required this.name,
    required this.constituency,
    required this.cnic,
    required this.email,
    required this.uid,
    required this.imageUrl,
  }) : super(key: key);

  final String name;
  final String constituency;
  final String cnic;
  final String email;
  final String uid;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: CupertinoColors.systemPink,
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          name,
        ),
        subtitle: Text(
          email,
        ),
        trailing: Text(
          constituency,
        ),
      ),
    );
  }
}

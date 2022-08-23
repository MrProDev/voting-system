import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/widgets/home/profile_picture_widget.dart';

class CandidateWidget extends StatelessWidget {
  const CandidateWidget({
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
    return Container(
      color: const CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.white,
        darkColor: CupertinoColors.darkBackgroundGray,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ProfilePictureWidget(
                    imageUrl: imageUrl,
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'profile',
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$name ($constituency)',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          CupertinoButton(
            onPressed: () {},
            child: const Text(
              'Show Details',
            ),
          ),
        ],
      ),
    );
  }
}

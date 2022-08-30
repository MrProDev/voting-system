import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:voting_system/widgets/vote/candidate_profile_details_widget.dart';

class CandidateWidget extends StatelessWidget {
  const CandidateWidget({
    Key? key,
    required this.seconds,
    required this.userUid,
    required this.candidateUid,
    required this.name,
    required this.constituency,
    required this.imageUrl,
    required this.partyImageUrl,
    required this.partyName,
  }) : super(key: key);

  final int seconds;
  final String userUid;
  final String candidateUid;
  final String name;
  final String constituency;
  final String imageUrl;
  final String partyName;
  final String partyImageUrl;

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
          Hero(
            tag: candidateUid,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: CachedNetworkImage(
                alignment: Alignment.topCenter,
                width: 64,
                height: 64,
                imageUrl: imageUrl,
                fit: BoxFit.cover,
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
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CandidateProfileDetailsWidget(
                  seconds: seconds,
                  userUid: userUid,
                  candidateUid: candidateUid,
                  name: name,
                  constituency: constituency,
                  imageUrl: imageUrl,
                  partyImageUrl: partyImageUrl,
                  partyName: partyName,
                ),
              ),
            ),
            child: const Text(
              'Show Details',
            ),
          ),
        ],
      ),
    );
  }
}

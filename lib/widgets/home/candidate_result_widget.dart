import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CandidateResultWidget extends StatelessWidget {
  const CandidateResultWidget({
    Key? key,
    required this.candidateUid,
    required this.constituency,
    required this.name,
    required this.imageUrl,
    required this.partyImageUrl,
    required this.partyName,
  }) : super(key: key);

  final String candidateUid;
  final String constituency;
  final String name;
  final String imageUrl;
  final String partyName;
  final String partyImageUrl;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('votes')
          .doc(constituency)
          .collection(candidateUid)
          .snapshots()
          .map(
            (event) => event.docs.length.toString(),
          ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else {
          final length = snapshot.data;
          return Container(
            color: const CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.white,
              darkColor: CupertinoColors.darkBackgroundGray,
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),
            child: Column(
              children: [
                const Icon(
                  CupertinoIcons.hand_thumbsup_fill,
                  size: 64,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  length.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: CachedNetworkImage(
                            alignment: Alignment.topCenter,
                            width: 64,
                            height: 64,
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: CachedNetworkImage(
                            alignment: Alignment.topCenter,
                            width: 64,
                            height: 64,
                            imageUrl: partyImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          partyName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

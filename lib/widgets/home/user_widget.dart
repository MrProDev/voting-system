import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key? key,
    required this.name,
    required this.constituency,
    required this.cnic,
    required this.email,
    required this.imageUrl,
  }) : super(key: key);

  final String name;
  final String constituency;
  final String cnic;
  final String email;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: CupertinoColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
          Text(constituency),
        ],
      ),
    );
  }
}

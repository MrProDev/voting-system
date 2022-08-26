import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/vote/vote_api.dart';

class CandidateProfileDetailsWidget extends StatefulWidget {
  const CandidateProfileDetailsWidget({
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
  State<CandidateProfileDetailsWidget> createState() =>
      _CandidateProfileDetailsWidgetState();
}

class _CandidateProfileDetailsWidgetState
    extends State<CandidateProfileDetailsWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Candidate Profile',
        ),
        previousPageTitle: 'Vote',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
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
                  tag: widget.candidateUid,
                  child: Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: const Text(
              'Party Name',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 18,
            ),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(
                color: CupertinoColors.lightBackgroundGray,
              ),
              color: const CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.white,
                darkColor: CupertinoColors.darkBackgroundGray,
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.partyName,
                ),
                const SizedBox(
                  width: 15,
                ),
                Image.network(
                  widget.partyImageUrl,
                  cacheWidth: 24,
                  cacheHeight: 24,
                  fit: BoxFit.cover,
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: const Text(
              'Constituency',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(
                color: CupertinoColors.lightBackgroundGray,
              ),
              color: const CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.white,
                darkColor: CupertinoColors.darkBackgroundGray,
              ),
            ),
            child: Text(
              widget.constituency,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: CupertinoButton(
              color: CupertinoColors.systemBlue,
              disabledColor: CupertinoColors.systemBlue.withOpacity(0.5),
              padding: EdgeInsets.zero,
              onPressed: () async {
                final voteApi = Provider.of<VoteApi>(context, listen: false);
                setState(() {
                  _isLoading = true;
                });

                if (widget.seconds <= 0) {
                  _showAlertDialog('Polling time has ended');
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                }

                final result = await voteApi.checkIfVoted(
                  userUid: widget.userUid,
                );

                if (result == true) {
                  _showAlertDialog('You have already casted your vote.\nVote cast can\'t be updated!');
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                } else {
                  _showAlertDialog('An error occurred');
                  setState(() {
                    _isLoading = false;
                  });
                }

                await voteApi.vote(
                  constituency: widget.constituency,
                  userUid: widget.userUid,
                  candidateUid: widget.candidateUid,
                );

                await voteApi.voteDone(userUid: widget.userUid, context: context,);

                setState(() {
                  _isLoading = false;
                });
              },
              child: _isLoading
                  ? const CupertinoActivityIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Vote',
                          style: TextStyle(
                            color: CupertinoColors.white,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          CupertinoIcons.hand_thumbsup,
                          color: CupertinoColors.white,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(String message) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}

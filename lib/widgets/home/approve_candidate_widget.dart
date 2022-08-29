import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/services/candidate/candidate_api.dart';

class ApproveCandidateWidget extends StatefulWidget {
  const ApproveCandidateWidget({
    Key? key,
    required this.uid,
    required this.name,
    required this.constituency,
    required this.isApproved,
    required this.imageUrl,
  }) : super(key: key);

  final String uid;
  final String name;
  final String constituency;
  final bool isApproved;
  final String imageUrl;

  @override
  State<ApproveCandidateWidget> createState() => _ApproveCandidateWidgetState();
}

class _ApproveCandidateWidgetState extends State<ApproveCandidateWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.imageUrl),
          radius: 28,
        ),
        title: Text(
          widget.name,
        ),
        subtitle: Text(
          widget.constituency,
        ),
        trailing: Container(
          width: 100,
          height: 30,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: CupertinoButton(
            borderRadius: BorderRadius.circular(5),
            padding: EdgeInsets.zero,
            color: widget.isApproved
                ? CupertinoColors.systemGreen
                : CupertinoColors.systemYellow,
            child: _isLoading
                ? const CupertinoActivityIndicator()
                : Text(widget.isApproved ? 'Approved' : 'Pending'),
            onPressed: () async {
              final candidateApi =
                  Provider.of<CandidateApi>(context, listen: false);

              CandidateData candidateData = CandidateData(
                  uid: widget.uid,
                  partyName: widget.name,
                  imageUrl: widget.imageUrl,
                  isApproved: widget.isApproved,
                  constituency: widget.constituency);
              setState(() {
                _isLoading = true;
              });

              await candidateApi.setCandidateAsApproved(
                context: context,
                uid: widget.uid,
                candidateData: candidateData,
              );
              setState(() {
                _isLoading = false;
              });
            },
          ),
        ),
      ),
    );
  }
}

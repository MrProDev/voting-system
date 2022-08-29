import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/widgets/home/approve_candidate_widget.dart';

class ApproveCandidatesScreen extends StatefulWidget {
  const ApproveCandidatesScreen({Key? key}) : super(key: key);

  static const route = '/ApproveCandidatesScreen';

  @override
  State<ApproveCandidatesScreen> createState() =>
      _ApproveCandidatesScreenState();
}

class _ApproveCandidatesScreenState extends State<ApproveCandidatesScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Approve Candidates'),
        previousPageTitle: 'Home',
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: StreamBuilder<List<UserData>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'userType',
                      isEqualTo: 'candidate',
                    )
                    .snapshots()
                    .map(
                      (snapshot) => snapshot.docs
                          .map(
                            (doc) => UserData.fromJson(
                              doc.data(),
                            ),
                          )
                          .toList(),
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
                    final users = snapshot.data!;
                    return StreamBuilder<List<CandidateData>>(
                      stream: FirebaseFirestore.instance
                          .collection('candidates')
                          .snapshots()
                          .map(
                            (snapshot) => snapshot.docs
                                .map(
                                  (doc) => CandidateData.fromJson(
                                    doc.data(),
                                  ),
                                )
                                .toList(),
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          final candidatesData = snapshot.data;
                          return ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: candidatesData!.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (context, index) =>
                                ApproveCandidateWidget(
                              uid: candidatesData[index].uid!,
                              isApproved: candidatesData[index].isApproved!,
                              name: users[index].name!,
                              constituency: candidatesData[index].constituency!,
                              imageUrl: users[index].imageUrl!,
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

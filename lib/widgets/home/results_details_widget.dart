import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/widgets/home/candidate_result_widget.dart';

class ResultsDetailsWidget extends StatelessWidget {
  const ResultsDetailsWidget({Key? key, required this.constituency}) : super(key: key);

  final String constituency;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Results',
        middle: Text(constituency),
      ),
      child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: StreamBuilder<List<UserData>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'constituency',
                      isEqualTo: constituency,
                    )
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
                    final users = snapshot.data;
                    return StreamBuilder<List<CandidateData>>(
                      stream: FirebaseFirestore.instance
                          .collection('candidates')
                          .where(
                            'constituency',
                            isEqualTo:
                                constituency,
                          ).where(
                            'isApproved',
                            isEqualTo: true,
                          )
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
                            itemBuilder: (context, index) => CandidateResultWidget(
                              
                              candidateUid: candidatesData[index].uid!,
                              constituency: candidatesData[index].constituency!,
                              name: users![index].name!,
                              imageUrl: users[index].imageUrl!,
                              partyName: candidatesData[index].partyName!,
                              partyImageUrl: candidatesData[index].imageUrl!,
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
    );
  }
}

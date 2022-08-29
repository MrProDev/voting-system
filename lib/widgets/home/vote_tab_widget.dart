import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/candidate_provider.dart';
import 'package:voting_system/providers/countdown_provider.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/widgets/vote/candidate_widget.dart';

class VoteTabWidget extends StatelessWidget {
  const VoteTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countdownProvider =
        Provider.of<CountdownProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final candidateProvider =
        Provider.of<CandidateProvider>(context, listen: false);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Vote'),
          ),
          
          SliverFillRemaining(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: StreamBuilder<List<UserData>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'constituency',
                      isEqualTo: userProvider.getConstituency(),
                    )
                    .where(
                      'userType',
                      whereIn: ['user', 'candidate'],
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
                                candidateProvider.getCandidateConstituency(),
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
                            itemBuilder: (context, index) => CandidateWidget(
                              seconds: countdownProvider.duration.inSeconds,
                              userUid: users![index].uid!,
                              candidateUid: candidatesData[index].uid!,
                              name: users[index].name!,
                              constituency: candidatesData[index].constituency!,
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
          ),
        ],
      ),
    );
  }
}

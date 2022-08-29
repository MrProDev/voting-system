import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/providers/candidate_provider.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/widgets/home/user_widget.dart';

class ShowUsersScreen extends StatefulWidget {
  const ShowUsersScreen({Key? key}) : super(key: key);

  static const route = '/ShowUsersScreen';

  @override
  State<ShowUsersScreen> createState() => _ShowUsersScreenState();
}

class _ShowUsersScreenState extends State<ShowUsersScreen> {
  String _name = '';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final candidateProvider =
        Provider.of<CandidateProvider>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Users'),
        previousPageTitle: 'Home',
      ),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await userProvider.getCurrentUser(context: context);
            },
          ),
          SliverFillRemaining(
            child: !candidateProvider.isApproved()
                ? const Center(
                    child: Text(
                      'Please wait for admin to approve your candidateship',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: CupertinoSearchTextField(
                          onChanged: (name) {
                            setState(() {
                              _name = name;
                            });
                          },
                        ),
                      ),
                      StreamBuilder<List<UserData>>(
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
                            final users = snapshot.data!;

                            return ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: users.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) {
                                if (users[index]
                                    .name!
                                    .toLowerCase()
                                    .contains(_name.toLowerCase())) {
                                  return UserWidget(
                                    name: users[index].name!,
                                    constituency: users[index].constituency!,
                                    cnic: users[index].cnic!,
                                    email: users[index].email!,
                                    imageUrl: users[index].imageUrl!,
                                  );
                                } else if (_name.isEmpty) {
                                  return UserWidget(
                                    name: users[index].name!,
                                    constituency: users[index].constituency!,
                                    cnic: users[index].cnic!,
                                    email: users[index].email!,
                                    imageUrl: users[index].imageUrl!,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

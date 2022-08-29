import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/services/candidate/candidate_api.dart';
import 'package:voting_system/providers/load_data.dart';
import 'package:voting_system/widgets/home/user_widget.dart';

class ShowUsersScreen extends StatefulWidget {
  const ShowUsersScreen({Key? key}) : super(key: key);

  static const route = '/ShowUsersScreen';

  @override
  State<ShowUsersScreen> createState() => _ShowUsersScreenState();
}

class _ShowUsersScreenState extends State<ShowUsersScreen> {
  bool? _isApproved;

  bool _isLoading = false;

  @override
  void initState() {
    _setData();

    super.initState();
  }

  _setData() {
    final isApproved = Provider.of<LoadData>(context, listen: false).isApproved;
    setState(() {
      _isApproved = isApproved;
    });
  }

  _getUpdatedData() async {
    final candidateApi = Provider.of<CandidateApi>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    final isApproved = await candidateApi.checkIfApproved();
    setState(() {
      _isApproved = isApproved;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Users'),
        previousPageTitle: 'Home',
      ),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _getUpdatedData();
            },
          ),
          SliverFillRemaining(
            child: _isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : !_isApproved!
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
                              onSuffixTap: () async {
                                _getUpdatedData();
                              },
                              onChanged: (name) {
                                setState(() {
                                  // _showUsersData = _showUsersData!
                                  //     .where((user) => user.name!
                                  //         .toLowerCase()
                                  //         .contains(name.toLowerCase()))
                                  //     .toList();
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
                                  itemBuilder: (context, index) => UserWidget(
                                    name: users[index].name!,
                                    constituency: users[index].constituency!,
                                    cnic: users[index].cnic!,
                                    email: users[index].email!,
                                    imageUrl: users[index].imageUrl!,
                                  ),
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

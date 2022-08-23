import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/home/apply_candidate_api.dart';
import 'package:voting_system/firebase/home/show_users_api.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/widgets/home/user_widget.dart';

class ShowUsersScreen extends StatefulWidget {
  const ShowUsersScreen({Key? key}) : super(key: key);

  static const route = '/ShowUsersScreen';

  @override
  State<ShowUsersScreen> createState() => _ShowUsersScreenState();
}

class _ShowUsersScreenState extends State<ShowUsersScreen> {
  String? _constituency;
  bool _isApproved = false;

  bool _isLoading = false;

  @override
  void initState() {
    _setData();

    super.initState();
  }

  _setData() async {
    final showUsersApi = Provider.of<ShowUsersApi>(context, listen: false);
    final applyCandidateApi =
        Provider.of<ApplyCandidateApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    var isApproved = await showUsersApi.checkIfApproved();
    final constituency = await applyCandidateApi.getConstituency();
    setState(() {
      _isApproved = isApproved;
      _constituency = constituency;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Users'),
      ),
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: _isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : !_isApproved
                ? const Center(
                    child: Text(
                      'Please wait for admin to approve your candidateship',
                      textAlign: TextAlign.center,
                    ),
                  )
                : StreamBuilder<List<UserData>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where(
                          'constituency',
                          isEqualTo: _constituency,
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

                        return ListView.separated(
                          itemCount: users.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) => UserWidget(
                            name: users[index].name!,
                            constituency: users[index].constituency!,
                            cnic: users[index].cnic!,
                            email: users[index].email!,
                            uid: users[index].uid!,
                            imageUrl: users[index].imageUrl!,
                          ),
                        );
                      }
                    },
                  ),
      ),
    );
  }
}

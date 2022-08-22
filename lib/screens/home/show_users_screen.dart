import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/widgets/home/user_widget.dart';

class ShowUsersScreen extends StatelessWidget {
  const ShowUsersScreen({Key? key}) : super(key: key);

  static const route = '/ShowUsersScreen';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Users'),
      ),
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: StreamBuilder<List<UserData>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where(
                'constituency',
                isEqualTo: args[0],
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
                itemBuilder: (context, index) => UsersWidget(
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

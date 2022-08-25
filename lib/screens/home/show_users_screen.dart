import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
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
  bool? _isApproved;

  List<UserData>? _usersData;

  bool _isLoading = false;

  @override
  void initState() {
    _setData();

    super.initState();
  }

  _setData() async {
    final showUsersApi = Provider.of<ShowUsersApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final isApproved = await showUsersApi.checkIfApproved();
    final usersData = await showUsersApi.getUsersData();
    setState(() {
      _isApproved = isApproved;
      _usersData = usersData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Users'),
        previousPageTitle: 'Home',
      ),
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
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
                : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                        child: CupertinoSearchTextField(
                          onSuffixTap: () async {
                            final showUsersApi = Provider.of<ShowUsersApi>(
                                context,
                                listen: false);
                            setState(() {
                              _isLoading = true;
                            });
                            final usersData = await showUsersApi.getUsersData();
                            setState(() {
                              _usersData = usersData;
                              _isLoading = false;
                            });
                          },
                          onSubmitted: (name) {
                            setState(() {
                              _usersData = _usersData!
                                  .where((user) => user.name!
                                      .toLowerCase()
                                      .contains(name.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _usersData!.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) => UserWidget(
                            name: _usersData![index].name!,
                            constituency: _usersData![index].constituency!,
                            cnic: _usersData![index].cnic!,
                            email: _usersData![index].email!,
                            imageUrl: _usersData![index].imageUrl!,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

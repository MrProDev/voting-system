import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/candidate/candidate_api.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/models/user_data.dart';
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

  List<UserData>? _showUsersData;

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
    final userApi = Provider.of<UserApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final isApproved = await candidateApi.checkIfApproved();
    final usersData = await userApi.getShowUsersData(context: context);
    setState(() {
      _isApproved = isApproved;
      _showUsersData = usersData;
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
                                onChanged: (name) {
                                  setState(() {
                                    _showUsersData = _showUsersData!
                                        .where((user) => user.name!
                                            .toLowerCase()
                                            .contains(name.toLowerCase()))
                                        .toList();
                                  });
                                },
                                onSubmitted: (name) {
                                  setState(() {
                                    _showUsersData = _showUsersData!
                                        .where((user) => user.name!
                                            .toLowerCase()
                                            .contains(name.toLowerCase()))
                                        .toList();
                                  });
                                },
                              ),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _showUsersData!.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) => UserWidget(
                                name: _showUsersData![index].name!,
                                constituency:
                                    _showUsersData![index].constituency!,
                                cnic: _showUsersData![index].cnic!,
                                email: _showUsersData![index].email!,
                                imageUrl: _showUsersData![index].imageUrl!,
                              ),
                            ),
                          ],
                        ),
            )
          ],
        ));
  }
}

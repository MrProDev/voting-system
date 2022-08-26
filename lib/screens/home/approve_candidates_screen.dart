import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/candidate/candidate_api.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/providers/load_data.dart';
import 'package:voting_system/widgets/home/approve_candidate_widget.dart';

class ApproveCandidatesScreen extends StatefulWidget {
  const ApproveCandidatesScreen({Key? key}) : super(key: key);

  static const route = '/ApproveCandidatesScreen';

  @override
  State<ApproveCandidatesScreen> createState() =>
      _ApproveCandidatesScreenState();
}

class _ApproveCandidatesScreenState extends State<ApproveCandidatesScreen> {
  List<CandidateData>? _candidatesData;
  List<UserData>? _usersData;

  bool _isLoading = false;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  _setData() {
    final usersData =
        Provider.of<LoadData>(context, listen: false).pendingUsersData;
    final candidatesData =
        Provider.of<LoadData>(context, listen: false).pendingCandidatesData;
    setState(() {
      _usersData = usersData;
      _candidatesData = candidatesData;
    });
  }

  _getUpdatedData() async {
    final userApi = Provider.of<UserApi>(context, listen: false);
    final candidateApi = Provider.of<CandidateApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final candidatesData = await candidateApi.getPendingCandidatesData();
    final usersData = await userApi.getPendingCandidatesData();
    setState(() {
      _candidatesData = candidatesData;
      _usersData = usersData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Approve Candidates'),
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
                : MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView(
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
                                _usersData = _usersData!
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
                          itemCount: _usersData!.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) =>
                              ApproveCandidateWidget(
                            uid: _candidatesData![index].uid!,
                            isApproved: _candidatesData![index].isApproved!,
                            name: _usersData![index].name!,
                            constituency: _candidatesData![index].constituency!,
                            imageUrl: _usersData![index].imageUrl!,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

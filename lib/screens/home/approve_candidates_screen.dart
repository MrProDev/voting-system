import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/services/candidate/candidate_api.dart';
import 'package:voting_system/models/candidate_data.dart';
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

  bool _isLoading = false;

  @override
  void initState() {
    _setData();
    setState(() {
      _candidatesData = Provider.of<LoadData>(context, listen: false).pendingCandidatesData;
    });
    
        

    super.initState();
  }

  _setData() async {
    await Provider.of<UsersProvider>(context, listen: false)
        .getUsers(context: context);
  }

  _getUpdatedData() async {
    final candidateApi = Provider.of<CandidateApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final candidatesData = await candidateApi.getPendingCandidatesData();
    setState(() {
      _candidatesData = candidatesData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
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
                              setState(
                                () {
                                  // userProvider.pendingUsers = userProvider.pendingUsers!
                                  //     .where((user) => user.name!
                                  //         .toLowerCase()
                                  //         .contains(name.toLowerCase()))
                                  //     .toList();
                                },
                              );
                            },
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: userProvider.pendingUsers!.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) =>
                              ApproveCandidateWidget(
                            uid: _candidatesData![index].uid!,
                            isApproved: _candidatesData![index].isApproved!,
                            name: userProvider.pendingUsers![index].name!,
                            constituency: _candidatesData![index].constituency!,
                            imageUrl:
                                userProvider.pendingUsers![index].imageUrl!,
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

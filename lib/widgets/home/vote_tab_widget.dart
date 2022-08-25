import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/candidate/candidate_api.dart';
import 'package:voting_system/firebase/home/countdown_time_api.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';
import 'package:voting_system/providers/load_data.dart';
import 'package:voting_system/widgets/vote/candidate_widget.dart';

class VoteTabWidget extends StatefulWidget {
  const VoteTabWidget({Key? key}) : super(key: key);

  @override
  State<VoteTabWidget> createState() => _VoteTabWidgetState();
}

class _VoteTabWidgetState extends State<VoteTabWidget> {
  List<CandidateData>? _candidatesData;
  List<UserData>? _usersData;
  int? _seconds;

  bool _isLoading = false;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  _setData() {
    final usersData = Provider.of<LoadData>(context, listen: false).usersData;
    final candidatesData =
        Provider.of<LoadData>(context, listen: false).candidatesData;
    final duration = Provider.of<LoadData>(context, listen: false).duration;
    setState(() {
      _usersData = usersData;
      _candidatesData = candidatesData;
      _seconds = duration!.inSeconds;
    });
  }

  _getUpdatedData() async {
    final userApi = Provider.of<UserApi>(context, listen: false);
    final countdownTimeApi =
        Provider.of<CountdownTimeApi>(context, listen: false);
    final candidateApi = Provider.of<CandidateApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final candidatesData =
        await candidateApi.getCandidatesData(context: context);
    final usersData = await userApi.getUsersData(context: context);
    final duration = await countdownTimeApi.getCountdownTimer();
    setState(() {
      _candidatesData = candidatesData;
      _usersData = usersData;
      _seconds = duration!.inSeconds;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Vote'),
          ),
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _candidatesData!.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) => CandidateWidget(
                        seconds: _seconds!,
                        userUid: FirebaseAuth.instance.currentUser!.uid,
                        candidateUid: _candidatesData![index].uid!,
                        name: _usersData![index].name!,
                        constituency: _candidatesData![index].constituency!,
                        imageUrl: _usersData![index].imageUrl!,
                        partyName: _candidatesData![index].partyName!,
                        partyImageUrl: _candidatesData![index].imageUrl!,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

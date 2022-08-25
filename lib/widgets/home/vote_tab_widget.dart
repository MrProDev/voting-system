import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/home/countdown_time_api.dart';
import 'package:voting_system/firebase/vote/show_candidates_api.dart';
import 'package:voting_system/models/candidate_data.dart';
import 'package:voting_system/models/user_data.dart';
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

  _setData() async {
    final showCandidatesApi =
        Provider.of<ShowCandidatesApi>(context, listen: false);
    final countdownTimeApi =
        Provider.of<CountdownTimeApi>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final candidatesData = await showCandidatesApi.getCandidatesData();
    final usersData = await showCandidatesApi.getUsersData();
    final duration = await countdownTimeApi.getCountdownTimer();
    setState(() {
      _candidatesData = candidatesData;
      _usersData = usersData;
      _seconds = duration.inSeconds;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Vote'),
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

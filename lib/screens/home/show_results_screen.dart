import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/common/common_data.dart';
import 'package:voting_system/widgets/home/results_details_widget.dart';

class ShowResultsScreen extends StatefulWidget {
  const ShowResultsScreen({Key? key}) : super(key: key);

  static const route = '/ShowResultsScreen';

  @override
  State<ShowResultsScreen> createState() => _ShowResultsScreenState();
}

class _ShowResultsScreenState extends State<ShowResultsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  fetchWinner() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Home',
        middle: Text('Results'),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Scrollbar(
              thumbVisibility: true,
              radius: const Radius.circular(10),
              controller: _scrollController,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: CommonData.constituencies.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: CupertinoColors.white,
                    child: GridTile(
                      footer: CupertinoButton(
                        child: const Text('Show Results'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ResultsDetailsWidget(
                                constituency: CommonData.constituencies[index],
                              ),
                            ),
                          );
                        },
                      ),
                      child: Center(
                        child: Text(
                          CommonData.constituencies[index],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

  String _constituencyName = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Home',
        middle: Text('Results'),
      ),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {},
          ),
          SliverFillRemaining(
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
                    onChanged: (constituencyName) {
                      setState(() {
                        _constituencyName = constituencyName;
                      });
                    },
                  ),
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  primary: false,
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: CommonData.constituencies.length,
                  itemBuilder: (context, index) {
                    if (_constituencyName.isEmpty) {
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
                                    constituency:
                                        CommonData.constituencies[index],
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
                    } else if (CommonData.constituencies[index]
                        .toLowerCase()
                        .contains(_constituencyName.toLowerCase())) {
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
                                    constituency:
                                        CommonData.constituencies[index],
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
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

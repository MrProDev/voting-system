import 'package:flutter/cupertino.dart';

class VoteTabWidget extends StatefulWidget {
  const VoteTabWidget({Key? key}) : super(key: key);

  @override
  State<VoteTabWidget> createState() => _VoteTabWidgetState();
}

class _VoteTabWidgetState extends State<VoteTabWidget> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text('Vote'),
          ),
          SliverFillRemaining(
            
          ),
        ],
      ),
    );
  }
}

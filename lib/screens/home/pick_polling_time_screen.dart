import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/services/home/countdown_time_api.dart';

class PickPollingTimeScreen extends StatefulWidget {
  const PickPollingTimeScreen({Key? key}) : super(key: key);

  static const route = '/PickPollingTimeScreen';

  @override
  State<PickPollingTimeScreen> createState() => _PickPollingTimeScreenState();
}

class _PickPollingTimeScreenState extends State<PickPollingTimeScreen> {
  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now();

  String _startTimeText = 'Start Time';
  String _endTimeText = 'End Time';

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Home',
        middle: Text('Pick Polling Time'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoFormSection(
              margin: const EdgeInsets.all(12),
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Text(
                            _startTimeText,
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: _startDateTime,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            _startDateTime = newDateTime;
                            _startTimeText =
                                '${DateFormat.yMMMEd().format(_startDateTime)} \t ${DateFormat.Hms().format(_startDateTime)}';
                          });
                          setState(() => _startDateTime = newDateTime);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Text(
                            _endTimeText,
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: _endDateTime,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            _endDateTime = newDateTime;
                            _endTimeText =
                                '${DateFormat.yMMMEd().format(_endDateTime)} \t ${DateFormat.Hms().format(_endDateTime)}';
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 32,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: CupertinoButton.filled(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final countdownTimeApi =
                      Provider.of<CountdownTimeApi>(context, listen: false);
                  setState(() {
                    _isLoading = true;
                  });
                  await countdownTimeApi.setCountdownTimer(
                      startPollingTime: _startDateTime,
                      endPollingTime: _endDateTime);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: _isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text(
                        'Set',
                        style: TextStyle(
                          color: CupertinoColors.white,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}

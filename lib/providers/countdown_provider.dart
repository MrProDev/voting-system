import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/services/home/countdown_time_api.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class CountdownProvider extends ChangeNotifier {
  Timer? _timer;
  Duration? _duration;
  String _warningMessage = '';

  DateTime? _startPollingTime;
  DateTime? _endPollingTime;

  Duration get duration => _duration!;
  String get warningMessage => _warningMessage;

  DateTime? get startPollingTime => _startPollingTime;
  DateTime? get endPollingTime => _endPollingTime;

  void durationAsNull() {
    _duration = null;
  }

  void warningMessageAsNull() {
    _warningMessage = '';
  }

  void timerAsNull() {
    _timer?.cancel();
    _timer = null;
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final seconds = _duration!.inSeconds - 1;
        final inSeconds = _duration!.inSeconds;
        if (inSeconds >=
            _endPollingTime!.difference(_startPollingTime!).inSeconds) {
          _warningMessage = 'Polling is not started yet';
          _timer?.cancel();
        } else if (seconds < 0) {
          _warningMessage = 'Polling time is ended!';
          _timer?.cancel();
        } else {
          _warningMessage = '';
          _duration = Duration(seconds: seconds);
        }
        notifyListeners();
      },
    );
  }

  Future setDuration({required BuildContext context}) async {
    final countdownTimeApi =
        Provider.of<CountdownTimeApi>(context, listen: false);

    _startPollingTime = await countdownTimeApi.startPollingTime();
    _endPollingTime = await countdownTimeApi.endPollingTime();

    tz.initializeTimeZones();

    final timeZone = tz.getLocation('Asia/Karachi');
    var now = tz.TZDateTime.now(timeZone);

    if (now.difference(_startPollingTime!).isNegative) {
      _duration = Duration(
          seconds: _endPollingTime!.difference(_startPollingTime!).inSeconds);
    } else if (_endPollingTime!.difference(now).isNegative) {
      _duration = const Duration(seconds: 0);
    } else {
      _duration = endPollingTime!.difference(now);
    }

    notifyListeners();
  }
}

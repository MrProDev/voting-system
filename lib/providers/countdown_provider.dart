import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/services/home/countdown_time_api.dart';

class CountdownProvider extends ChangeNotifier {
  Timer? _timer;
  Duration? _duration;
  String _warningMessage = '';

  Duration get duration => _duration!;
  String get warningMessage => _warningMessage;

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
        final hours = duration.inHours;
        if (hours >= 8) {
          _warningMessage = 'Polling is not started yet!';
          _timer?.cancel();
        }
        if (seconds < 0) {
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
    _duration = await countdownTimeApi.getCountdownTimer();

    notifyListeners();
  }
}

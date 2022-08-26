import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/home/countdown_time_api.dart';

class CountdownProvider extends ChangeNotifier {
  Duration? duration;
  String warningMessage = '';
  String hours = '';
  String minutes = '';
  String seconds = '';

  void getDuration({required BuildContext context}) async {
    final countdownTimeApi =
        Provider.of<CountdownTimeApi>(context, listen: false);
    duration = await countdownTimeApi.getCountdownTimer();
  }

  

  void setDuration() {
    if (duration!.inHours >= 8) {
      warningMessage = 'Polling is not started yet!';
    } else if (duration!.inSeconds <= 0) {
      warningMessage = 'Polling time is ended!';
    } else {
      warningMessage = '';
    }

    setData();

    notifyListeners();
  }

  void setData() {
    minutes = twoDigits(duration!.inMinutes.remainder(60));
    seconds = twoDigits(duration!.inSeconds.remainder(60));
    hours = twoDigits(duration!.inHours.remainder(60));
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
}

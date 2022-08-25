import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class CountdownTimeApi {
  Future<Duration> getCountdownTimer() async {
    tz.initializeTimeZones();

    final timeZone = tz.getLocation('Asia/Karachi');
    var now = tz.TZDateTime.now(timeZone);

    final doc = await FirebaseFirestore.instance
        .collection('countdowntime')
        .doc('countdown timer')
        .get();

    final Timestamp startPollingTimeData = doc.data()!['startPollingTime'];
    final Timestamp endPollingTimeData = doc.data()!['endPollingTime'];

    DateTime startPollingTime = startPollingTimeData.toDate();
    DateTime endPollingTime = endPollingTimeData.toDate();

    if (now.difference(startPollingTime).isNegative) {
      return Duration(
          hours: endPollingTime.difference(startPollingTime).inHours);
    } else if (endPollingTime.difference(now).isNegative) {
      return const Duration(seconds: 0);
    } else {
      return endPollingTime.difference(now);
    }
  }
}

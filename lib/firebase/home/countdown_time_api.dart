import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class CountdownTimeApi {
  Future<Duration?> getCountdownTimer() async {
    try {
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
    } on PlatformException {
      return null;
    }
  }

  Future setCountdownTimer({
    required DateTime startPollingTime,
    required DateTime endPollingTime,
  }) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('countdowntime')
          .doc('countdown timer');

      await doc.set({
        'startPollingTime': Timestamp.fromDate(startPollingTime),
        'endPollingTime': Timestamp.fromDate(endPollingTime),
      });
    } on PlatformException {
      return null;
    }
  }
}

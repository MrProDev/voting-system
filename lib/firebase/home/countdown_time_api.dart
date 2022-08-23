import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CountdownTimeApi {
  Future<Duration?> getCountdownTimer() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('countdowntime')
          .doc('countdown timer')
          .get();

      final Timestamp startPollingTimeData = doc.data()!['startPollingTime'];
      final Timestamp endPollingTimeData = doc.data()!['endPollingTime'];

      DateTime now = DateTime.now();

      DateTime startPollingTime = startPollingTimeData.toDate();
      DateTime endPollingTime = endPollingTimeData.toDate();

      if (now.difference(startPollingTime).isNegative) {
        return const Duration(seconds: 0);
      } else if (endPollingTime.difference(now).isNegative) {
        return const Duration(seconds: 0);
      } else {
        return endPollingTime.difference(now);
      }
    } on PlatformException {
      return null;
    }
  }
}

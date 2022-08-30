import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CountdownTimeApi {

  Future<DateTime?> startPollingTime() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('countdowntime')
          .doc('countdown timer')
          .get();

      final Timestamp startPollingTimeData = doc.data()!['startPollingTime'];

      return startPollingTimeData.toDate();
    } on PlatformException {
      return null;
    }
  }

  Future<DateTime?> endPollingTime() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('countdowntime')
          .doc('countdown timer')
          .get();

      final Timestamp endPollingTimeData = doc.data()!['endPollingTime'];

      return endPollingTimeData.toDate();
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

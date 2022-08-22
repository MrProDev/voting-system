import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class VerifyEmailApi {
  Future sendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } on PlatformException catch (err) {
      return err.message;
    }
  }
}

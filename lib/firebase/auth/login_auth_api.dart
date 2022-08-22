import 'package:firebase_auth/firebase_auth.dart';

class LoginAuthApi {
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException {
      return null;
    }
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }
}

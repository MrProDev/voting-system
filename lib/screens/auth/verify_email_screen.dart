import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/auth/login_auth_api.dart';
import 'package:voting_system/firebase/auth/verify_email_api.dart';
import 'package:voting_system/screens/home/home_screen.dart';
import 'package:voting_system/widgets/app_icon_widget.dart';
import 'package:voting_system/widgets/shader_mask_widget.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {



  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  bool _loading = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isEmailVerified) {
      final verifyEmailApi =
          Provider.of<VerifyEmailApi>(context, listen: false);
      verifyEmailApi.sendEmailVerification();
      _timer = Timer.periodic(
        const Duration(
          seconds: 5,
        ),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (_isEmailVerified) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified
        ? const HomeScreen()
        : CupertinoPageScaffold(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 12, bottom: 12),
                    child: const AppIconWidget(),
                  ),
                  const ShaderMaskWidget(
                    child: Text(
                      'A verification Email has been sent to you!',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemPurple,
                          CupertinoColors.systemPink,
                          CupertinoColors.systemYellow,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _canResendEmail ? _sendVerification : null,
                      child: _loading
                          ? const CupertinoActivityIndicator()
                          : const Text(
                              'Resend Email',
                              style: TextStyle(
                                color: CupertinoColors.white,
                              ),
                            ),
                    ),
                  ),
                  ShaderMaskWidget(
                    child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('Cancel'),
                        onPressed: () {
                          final loginAuthApi =
                              Provider.of<LoginAuthApi>(context, listen: false);
                          loginAuthApi.signOut();
                        }),
                  ),
                ],
              ),
            ),
          );
  }

  void _sendVerification() async {
    setState(() {
      _loading = true;
    });

    final verifyEmailApi = Provider.of<VerifyEmailApi>(context, listen: false);
    verifyEmailApi.sendEmailVerification();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      _loading = false;
      _canResendEmail = false;
    });

    await Future.delayed(
      const Duration(seconds: 10),
    );

    setState(() {
      _canResendEmail = true;
    });
  }
}

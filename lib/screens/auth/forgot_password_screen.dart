import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/auth/forgot_password_api.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  static const route = '/ForgotPasswordScreen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

  // Loading state
  bool _loading = false;

  String? _email;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 12, bottom: 12),
              child: const Icon(
              CupertinoIcons.hand_thumbsup_fill,
              size: 128,
            ),
            ),
            CupertinoFormSection(
              margin: const EdgeInsets.all(12),
              children: [
                CupertinoTextFormFieldRow(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefix: const Icon(CupertinoIcons.mail),
                  placeholder: 'Email Address',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email Address cannot be empty';
                    } else if (!_emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (email) {
                    _email = email;
                  },
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: CupertinoButton.filled(
                padding: EdgeInsets.zero,
                onPressed: _resetPassword,
                child: _loading
                    ? const CupertinoActivityIndicator()
                    : const Text(
                        'Reset Password',
                        style: TextStyle(
                          color: CupertinoColors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword() async {
    final isValid = _formKey.currentState!.validate();
    final forgotPasswordApi =
        Provider.of<ForgotPasswordApi>(context, listen: false);

    if (isValid) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();
    } else {
      return;
    }

    setState(() {
      _loading = true;
    });

    final inUse = await forgotPasswordApi.checkIfEmailInUse(_email!);

    if (!inUse) {
      setState(() {
        _loading = false;
      });
      _showAlertDialog('Account with this email does not exist!');
      return;
    }
    final result =
        await forgotPasswordApi.sendPasswordResetEmail(email: _email!);
    if (result == 1) {
      setState(() {
        _loading = false;
      });
      _showAlertDialog('Could not send reset email!');
      return;
    }

    setState(() {
      _loading = false;
    });
    _showAlertDialog('Please check your mail to reset password!');
  }

  void _showAlertDialog(String message) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}

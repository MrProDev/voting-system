import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/auth/login_auth_api.dart';
import 'package:voting_system/screens/auth/forgot_password_screen.dart';
import 'package:voting_system/screens/auth/signup_screen.dart';
import 'package:voting_system/widgets/app_icon_widget.dart';
import 'package:voting_system/widgets/shader_mask_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

  // Loading state
  bool _loading = false;

  String? _email;
  String? _password;

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
              child: const AppIconWidget(),
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
                  prefix: const ShaderMaskWidget(
                    child: Icon(CupertinoIcons.mail),
                  ),
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
                CupertinoTextFormFieldRow(
                  prefix: const ShaderMaskWidget(
                    child: Icon(CupertinoIcons.lock),
                  ),
                  placeholder: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (password) {
                    _password = password;
                  },
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(
                right: 12,
              ),
              child: ShaderMaskWidget(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Forgot Password?'),
                  onPressed: () =>
                      Navigator.pushNamed(context, ForgotPasswordScreen.route),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                onPressed: _verifyCredentials,
                child: _loading
                    ? const CupertinoActivityIndicator()
                    : const Text(
                        'Sign in',
                        style: TextStyle(
                          color: CupertinoColors.white,
                        ),
                      ),
              ),
            ),
            ShaderMaskWidget(
              child: CupertinoButton(
                child: const Text('Don\'t have an account yet?'),
                onPressed: () =>
                    Navigator.pushNamed(context, SignUpScreen.route),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyCredentials() async {
    final isValid = _formKey.currentState!.validate();
    final loginAuthApi = Provider.of<LoginAuthApi>(context, listen: false);

    if (isValid) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();
    } else {
      return;
    }

    setState(() {
      _loading = true;
    });

    User? user =
        await loginAuthApi.signInWithEmailAndPassword(_email!, _password!);

    if (user == null) {
      _showAlertDialog();
    }

    setState(() {
      _loading = false;
    });
  }

  void _showAlertDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('User does not exist'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}

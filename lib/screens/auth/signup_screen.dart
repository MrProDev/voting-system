import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/common/common_data.dart';
import 'package:voting_system/firebase/auth/signup_auth_api.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const route = '/SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
  final _passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final _cnicRegex = RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]{1}$');

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Loading state
  bool _loading = false;

  String? _name;
  int _selectedConstituency = 0;
  String? _cnic;
  String? _email;
  String? _password;

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 150,
        maxHeight: 150,
      );
      if (image == null) {
        return;
      }

      final tempImageFile = File(image.path);
      setState(() {
        this.image = tempImageFile;
      });
    } on PlatformException {
      _showAlertDialog('Failed to pick image ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80.0),
                      child: image == null
                          ? Icon(
                              CupertinoIcons.person_alt_circle,
                              color:
                                  CupertinoColors.systemBlue.withOpacity(0.5),
                              size: 128,
                            )
                          : Image.file(
                              image!,
                              fit: BoxFit.cover,
                              height: 128,
                              width: 128,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _showActionSheet,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: CupertinoColors.systemBlue,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              image == null
                  ? const Text(
                      'Please choose your profile picture',
                      style: TextStyle(
                        color: CupertinoDynamicColor.withBrightness(
                          color: CupertinoColors.black,
                          darkColor: CupertinoColors.white,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : const SizedBox(
                      height: 10,
                    ),
              CupertinoFormSection(
                margin: const EdgeInsets.all(12),
                children: [
                  CupertinoTextFormFieldRow(
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    prefix: const Icon(CupertinoIcons.profile_circled),
                    placeholder: 'Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (name) {
                      _name = name;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 19.5),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          const Icon(Icons.where_to_vote_outlined),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(CommonData
                                .constituencies[_selectedConstituency]),
                          ),
                        ],
                      ),
                      onPressed: () => _showDialog(
                        CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (int constituency) {
                            setState(() {
                              _selectedConstituency = constituency;
                            });
                          },
                          children: List<Widget>.generate(
                            CommonData.constituencies.length,
                            (int index) => Center(
                              child: Text(
                                CommonData.constituencies[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CupertinoTextFormFieldRow(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    prefix: const Icon(Icons.numbers_outlined),
                    placeholder: 'CNIC',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'CNIC cannot be empty';
                      } else if (!_cnicRegex.hasMatch(value)) {
                        return 'Please enter a valid CNIC';
                      }
                      return null;
                    },
                    onSaved: (cnic) {
                      _cnic = cnic;
                    },
                  ),
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
                  CupertinoTextFormFieldRow(
                    prefix: const Icon(CupertinoIcons.lock),
                    placeholder: 'Password',
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (!_passwordRegex.hasMatch(value)) {
                        return 'Password must have at least 8 characters including\nOne upper case letter\nOne number\nOne special character';
                      }
                      return null;
                    },
                    onSaved: (password) {
                      _password = password;
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Icon(CupertinoIcons.lock),
                    placeholder: 'Confirm Password',
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Password cannot be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CupertinoButton.filled(
                  padding: EdgeInsets.zero,
                  onPressed: _verifyCredentials,
                  child: _loading
                      ? const CupertinoActivityIndicator()
                      : const Text(
                          'Sign up',
                          style: TextStyle(
                            color: CupertinoColors.white,
                          ),
                        ),
                ),
              ),
              CupertinoButton(
                child: const Text('Already have an account?'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyCredentials() async {
    final isValid = _formKey.currentState!.validate();
    final signUpAuthApi = Provider.of<SignUpAuthApi>(context, listen: false);

    if (_passwordController.text != _confirmPasswordController.text) {
      _showAlertDialog('Passwords don\'t match!');
      return;
    }

    if (isValid && image != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();
    } else {
      return;
    }

    setState(() {
      _loading = true;
    });

    User? user =
        await signUpAuthApi.createUserWithEmailAndPassword(_email!, _password!);

    if (user == null) {
      _showAlertDialog('User with this email address already exists');
      setState(() {
        _loading = false;
      });
      return;
    } else {
      final imageUrl = await signUpAuthApi.uploadProfilePicture(image: image!);
      await signUpAuthApi.createUser(
        name: _name!,
        constituency: CommonData.constituencies[_selectedConstituency],
        cnic: _cnic!,
        user: user,
        imageUrl: imageUrl!,
      );
    }

    setState(() {
      _loading = false;
    });
    if (!mounted) return;
    Navigator.pop(context);
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
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _showActionSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
            child: const Text(
              'Take Photo',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
            child: const Text(
              'Choose Photo',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}

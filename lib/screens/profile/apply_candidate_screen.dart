import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/services/home/apply_candidate_api.dart';

class ApplyCandidateScreen extends StatefulWidget {
  const ApplyCandidateScreen({Key? key}) : super(key: key);

  static const route = '/ApplyCandidateScreen';

  @override
  State<ApplyCandidateScreen> createState() => _ApplyCandidateScreenState();
}

class _ApplyCandidateScreenState extends State<ApplyCandidateScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _partyName;
  File? _image;

  bool _loading = false;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 25,
        maxWidth: 150,
        maxHeight: 150,
      );
      if (image == null) {
        return;
      }

      final tempImageFile = File(image.path);
      setState(() {
        _image = tempImageFile;
      });
    } on PlatformException {
      _showAlertDialog('Failed to pick image ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Apply for Candidateship'),
        previousPageTitle: 'Profile',
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                      child: _image == null
                          ? Icon(
                              CupertinoIcons.person_alt_circle,
                              size: 128,
                              color:
                                  CupertinoColors.systemBlue.withOpacity(0.5),
                            )
                          : Image.file(
                              _image!,
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
              const SizedBox(
                height: 20,
              ),
              CupertinoFormSection(
                margin: const EdgeInsets.all(12),
                children: [
                  CupertinoTextFormFieldRow(
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    prefix: const Icon(Icons.celebration_outlined),
                    placeholder: 'Party Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Party name cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (partyName) {
                      _partyName = partyName;
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CupertinoButton.filled(
                  padding: EdgeInsets.zero,
                  onPressed: _verifyCredentials,
                  child: _loading
                      ? const CupertinoActivityIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Apply',
                              style: TextStyle(
                                color: CupertinoColors.white,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.approval,
                              color: CupertinoColors.white,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyCredentials() async {
    final isValid = _formKey.currentState!.validate();
    final apply = Provider.of<ApplyCandidateApi>(context, listen: false);

    if (isValid && _image != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();
    } else if (_image == null) {
      _showAlertDialog('Please choose your party picture');
      return;
    } else {
      return;
    }

    setState(() {
      _loading = true;
    });

    final result = await apply.checkIfCandidateExists();
    if (result == true) {
      _showAlertDialog('You have already applied for a candidateship');
      setState(() {
        _loading = false;
      });
      return;
    } else if (result == null) {
      _showAlertDialog('An error occurred');
      setState(() {
        _loading = false;
      });
      return;
    }

    await apply.applyForCandidate(partyName: _partyName!, image: _image!, context: context);
    setState(() {
      _loading = false;
    });
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
}

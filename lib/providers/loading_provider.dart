import 'package:flutter/cupertino.dart';

class LoadingProvider extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  void yesLoading() {
    _loading = true;
    notifyListeners();
  }

  void noLoading() {
    _loading = false;
    notifyListeners();
  }

}

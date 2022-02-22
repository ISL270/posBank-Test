import 'package:flutter/material.dart';

class ModeProvider extends ChangeNotifier {
  bool _useSQLite = true;

  bool get useSQLite => _useSQLite;

  void toggleMode() {
    _useSQLite = !_useSQLite;
    print(_useSQLite);
    notifyListeners();
  }
}

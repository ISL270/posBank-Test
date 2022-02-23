import 'package:flutter/material.dart';

class ModeProvider extends ChangeNotifier {
  bool _useSQLite = false;

  bool get useSQLite => _useSQLite;

  void toggleMode() {
    _useSQLite = !_useSQLite;
    notifyListeners();
  }
}

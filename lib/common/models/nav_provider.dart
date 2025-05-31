import 'package:flutter/material.dart';

class NavProvider with ChangeNotifier {
  String _currentTitle = "TOWN TEAM";

  String get currentTitle => _currentTitle;

  void setTitle(String title) {
    _currentTitle = title;
    notifyListeners();
  }
}

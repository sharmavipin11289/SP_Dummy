import 'package:flutter/material.dart';


class TabControllerProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeTabIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
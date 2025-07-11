import 'package:flutter/material.dart';
import 'package:sanaa/l10n/l10n.dart';


class LocalProvider extends ChangeNotifier {
  Locale  _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale){
    if(!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale(){
    _locale = Locale('en');
    notifyListeners();
  }
}
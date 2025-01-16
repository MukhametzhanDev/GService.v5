import 'package:flutter/material.dart';

class NameCompanyProvider extends ChangeNotifier {
  String name = "";
  bool hasDealer = false;

  String get nameValue => name;
  bool get dealerValue => hasDealer;

  set changedName(String value) {
    name = value;
    notifyListeners();
  }

  set changedHasDealer(bool value) {
    hasDealer = value;
    notifyListeners();
  }
}

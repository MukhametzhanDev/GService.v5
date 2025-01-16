import 'package:flutter/material.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';

class StatusMyAdCountProvider with ChangeNotifier {
  Map counts = {};
  bool loading = true;

  Map get value => counts;

  getData(int data) async {
    loading = true;
    counts = await MyAdRequest().getCount(data);
    loading = false;
    notifyListeners();
  }

  void plusArichvedCount() {
    counts['pending'] -= 1;
    counts['archived'] += 1;
    notifyListeners();
  }

  void plusRemovedCount() {
    counts['pending'] -= 1;
    counts['deleted'] += 1;
    notifyListeners();
  }

  void minusArichvedCount() {
    counts['archived'] -= 1;
    counts['pending'] += 1;
    notifyListeners();
  }

  void minusRemovedCount() {
    counts['deleted'] -= 1;
    counts['pending'] += 1;
    notifyListeners();
  }
}

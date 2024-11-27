import 'package:flutter/material.dart';

class PageControllerIndexedStack {
  // Singleton instance
  static final PageControllerIndexedStack _instance =
      PageControllerIndexedStack._internal();

  factory PageControllerIndexedStack() {
    return _instance;
  }

  PageControllerIndexedStack._internal();

  final ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);

  void changePage(int index) {
    pageIndexNotifier.value = index;
  }

  void nextPage() {
    pageIndexNotifier.value += 1;
  }

  void previousPage() {
    if (pageIndexNotifier.value > 0) {
      pageIndexNotifier.value -= 1;
    }
  }

  int getIndex() {
    return pageIndexNotifier.value;
  }

  void dispose() {
    pageIndexNotifier.value = 0;
  }
}

import 'package:flutter/material.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';

Map<String, dynamic> defaultFilterData = {"status": "pending", "package": true};

class MyAdFilterProvider with ChangeNotifier {
  List<Map<String, dynamic>> filters = [];
  bool loading = false;
  List ads = [];
  int currentIndex = 0;

  int get currentCategoryId =>
      filters.isEmpty ? 0 : filters[currentIndex]['category_id'];

  set addFilters(List<Map<String, dynamic>> value) {
    filters = value;
    getData();
  }

  set addFilter(Map<String, dynamic> value) {
    if (filters.isEmpty) {
      filters.add(value);
    } else {
      filters[currentIndex].addAll(value);
    }
    getData();
  }

  clearData() {
    filters.clear();
    changedIndex = 0;
  }

  set changedIndex(int index) {
    currentIndex = index;
    getData();
  }

  void getData() async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> filterValue =
        filters.isEmpty ? {} : filters[currentIndex];

    ads = await MyAdRequest().myAds(filterValue);

    loading = false;
    notifyListeners();
  }

  addDefaultDataFilter(List data) {
    if (filters.isEmpty) {
      for (Map value in data) {
        filters.add({...defaultFilterData, "category_id": value['id']});
      }
    }
  }
}

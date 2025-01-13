import 'package:flutter/material.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';

Map<String, dynamic> defaultFilterData = {"status": "pending", "package": true};

class MyAdFilterProvider with ChangeNotifier {
  List<Map<String, dynamic>> filters = [];
  bool loading = true;
  List ads = [];
  int currentIndex = 0;

  // Map get filterValue => filters.isEmpty ? {} : filters[currentIndex];

  set addFilters(List<Map<String, dynamic>> value) {
    filters = value;
    getData();
  }

  set addFilter(Map<String, dynamic> value) {
    filters[currentIndex].addAll(value);
    getData();
  }

  getData() async {
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

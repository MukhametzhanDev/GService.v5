// AdFilterResultCountProvider

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';

class AdFilterProvider extends ChangeNotifier {
  Map<String, dynamic> data = {};
  int count = 0;

  Map<String, dynamic> get value => data;
  int get countValue => count;

  getCountAd() async {
    count = await GetAdFilterCount().getData(data);
    print(count);
    notifyListeners();
  }

  changedCategory(int value) {
    data.addAll({"category_id": value});
  }

  set filterData(Map<String, dynamic> newValue) {
    // data = newValue;
    data.addAll(newValue);
    notifyListeners();

    getCountAd();
  }

  set removeData(String key) {
    // data = newValue;
    data.remove(key);
    notifyListeners();

    getCountAd();
  }

  clearData() {
    // data = newValue;
    data.removeWhere((key, value) => key != "category_id");
    notifyListeners();

    getCountAd();
  }
}

class GetAdFilterCount {
  Future<int> getData(Map<String, dynamic> param) async {
    int count = 0;
    try {
      Response response =
          await dio.get("/ad-filtered-count", queryParameters: param);
      print(response.data);
      if (response.data['success']) {
        count = response.data['data']['count'];
      }
    } finally {
      return count;
    }
  }
}

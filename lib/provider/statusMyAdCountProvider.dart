import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';

class StatusMyAdCountProvider with ChangeNotifier {
  Map counts = {};
  bool loading = true;

  Map get value => counts;

  getData(Map? data) async {
    loading = true;
    counts = await getCount(data);
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

Future<Map> getCount(data) async {
  Map data = {
    "pending": 0,
    "confirmed": 0,
    "canceled": 0,
    "archived": 0,
    "deleted": 0
  };
  Map<String, dynamic> param = {};
  if (data.isNotEmpty) {
  print("PARAM ---> $param");
    // param.addAll(data['id']);
  }
  try {
    Response response =
        await dio.get("/my-ads-status-count", queryParameters: param);
    if (response.data['success']) {
      data = response.data['data'];
    }
  } finally {
    return data;
  }
}

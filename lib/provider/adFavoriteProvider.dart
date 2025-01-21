import 'package:flutter/material.dart';

class AdFavoriteProvider extends ChangeNotifier {
  Map<int, Map> data = {};

  Map get value => data;

  set addAd(Map value) {
    data.addAll({value['id']: value});
    print(data);
    notifyListeners();
  }

  set addAds(List value) {
    value.forEach((element) {
      element = element['favoritable'];
      data.addAll({element['id']: element});
    });
    notifyListeners();
  }

  set updateAds(List value) {
    Map<int, Map> ads = {};
    value.forEach((element) {
      element = element['favoritable'];
      ads.addAll({element['id']: element});
    });
    data = ads;
    notifyListeners();
  }

  bool checkAd(Map value) {
    return data.containsKey(value['id']);
  }

  set removeAd(Map value) {
    data.remove(value['id']);
    notifyListeners();
  }
}

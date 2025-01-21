import 'package:flutter/material.dart';

class ApplicationFavoriteProvider extends ChangeNotifier {
  Map<int, Map> data = {};

  Map get value => data;

  set addApplication(Map value) {
    data.addAll({value['id']: value});
    print(data);
    notifyListeners();
  }

  set addApplications(List value) {
    value.forEach((element) {
      element = element['favoritable'];
      data.addAll({element['id']: element});
    });
    notifyListeners();
  }

  set updateApplications(List value) {
    Map<int, Map> applications = {};
    value.forEach((element) {
      element = element['favoritable'];
      applications.addAll({element['id']: element});
    });
    data = applications;
    notifyListeners();
  }

  bool checkApplication(Map value) {
    return data.containsKey(value['id']);
  }

  set removeApplication(Map value) {
    data.remove(value['id']);
    notifyListeners();
  }
}

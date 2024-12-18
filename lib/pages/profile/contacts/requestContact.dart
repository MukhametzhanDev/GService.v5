import 'package:dio/dio.dart';
import 'package:gservice5/component/dio/dio.dart';

class RequestContact {
  Future<List> getCountries() async {
    try {
      Response response = await dio.get("/countries");
      if (response.data['success']) {
        return response.data['data'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List> getSocialNetworks() async {
    try {
      Response response = await dio.get("/social-networks");
      if (response.data['success']) {
        return response.data['data'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

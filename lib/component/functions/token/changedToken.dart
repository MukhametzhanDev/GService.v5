import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/navigation/individual/individualBottomTab.dart';
import 'package:gservice5/component/dio/dio.dart';

class ChangedToken {
  Future saveIndividualToken(value, context) async {
    await const FlutterSecureStorage().write(key: "role", value: "individual");
    await const FlutterSecureStorage()
        .write(key: "token", value: value['user_token']);
    dio.options.headers['authorization'] = "Bearer ${value['user_token']}";
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => IndividualBottomTab()),
        (route) => false);
  }

  Future removeIndividualToken(context) async {
    try {
      showModalLoader(context);
      Response response = await dio.post("/logout");
      print(response.data);
      Navigator.pop(context);
      await const FlutterSecureStorage().delete(key: "token");
      dio.options.headers['authorization'] = "";
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => IndividualBottomTab()),
          (route) => false);
    } catch (e) {}
  }

  Future saveCustomerToken(value, context) async {
    await const FlutterSecureStorage().write(key: "role", value: "customer");
    await const FlutterSecureStorage()
        .write(key: "token", value: value['user_token']);
    dio.options.headers['authorization'] = "Bearer ${value['user_token']}";
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => IndividualBottomTab()),
        (route) => false);
  }
}

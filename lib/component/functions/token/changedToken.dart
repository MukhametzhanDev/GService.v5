import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/navigation/bottomTab.dart';
import 'package:gservice5/component/dio/dio.dart';

class ChangedToken {
  Future saveToken(value, context) async {
    print(value);
    await const FlutterSecureStorage()
        .write(key: "token", value: value['user_token']);
    dio.options.headers['authorization'] = "Bearer ${value['user_token']}";
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => BottomTab()), (route) => false);
  }

  Future removeToken(context) async {
    try {
      showModalLoader(context);
      Response response = await dio.post("/logout");
      print(response.data);
      Navigator.pop(context);
      await const FlutterSecureStorage().delete(key: "token");
      dio.options.headers['authorization'] = "";
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => BottomTab()), (route) => false);
    } catch (e) {}
  }
}

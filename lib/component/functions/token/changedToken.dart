import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/navigation/customer/customerBottomTab.dart';
import 'package:gservice5/component/dio/dio.dart';

class ChangedToken {
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  Future getToken() async {
    String? token = await flutterSecureStorage.read(key: "token");
    return token;
  }

  Future getRole() async {
    String? role = await flutterSecureStorage.read(key: "role");
    return role ?? "";
  }

  Future savedToken(value, context) async {
    await flutterSecureStorage.write(key: "role", value: "customer");
    await flutterSecureStorage.write(key: "token", value: value['user_token']);
    dio.options.headers['authorization'] = "Bearer ${value['user_token']}";
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CustomerBottomTab()),
        (route) => false);
  }

  Future removeToken(context) async {
    try {
      showModalLoader(context);
      Response response = await dio.post("/logout");
      print(response.data);
      Navigator.pop(context);
      await flutterSecureStorage.deleteAll();
      dio.options.headers['authorization'] = "";
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  // Future changeIndividualToken(context) async {
  //   await flutterSecureStorage.write(key: "role", value: "customer");
  //   String? token = await flutterSecureStorage.read(key: "token");
  //   dio.options.baseUrl = "https://dev.gservice-co.kz/api/";
  //   dio.options.headers['authorization'] = "Bearer $token";
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const CustomerBottomTab()),
  //       (route) => false);
  // }

  // Future saveCustomerToken(value, context) async {
  //   await flutterSecureStorage.write(key: "role", value: "customer");
  //   await flutterSecureStorage.write(
  //       key: "token_customer", value: value['user_token']);
  //   dio.options.headers['authorization'] = "Bearer ${value['user_token']}";
  //   dio.options.baseUrl = "https://dev.gservice-co.kz/api/business/";
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const CustomerBottomTab()),
  //       (route) => false);
  // }

  // Future changedCustomerToken(context) async {
  //   await flutterSecureStorage.write(key: "role", value: "customer");
  //   String? token = await flutterSecureStorage.read(key: "token_customer");
  //   dio.options.headers['authorization'] = "Bearer $token";
  //   dio.options.baseUrl = "https://dev.gservice-co.kz/api/business/";
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const CustomerBottomTab()),
  //       (route) => false);
  // }

  // Future saveContractorToken(value, String type, BuildContext context) async {
  //   await flutterSecureStorage.write(key: "role", value: "contractor");
  //   await flutterSecureStorage.write(
  //       key: "token_contractor", value: value['user_token']);
  //   dio.options.headers['authorization'] = "Bearer ${value['user_token']}";
  //   dio.options.baseUrl = "https://dev.gservice-co.kz/api/business/";
  //   if (type == "login") {
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (_) => const BusinessBottomTab()),
  //         (route) => false);
  //   } else {
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (_) => const GetActivityContractorPage()),
  //         (route) => false);
  //   }
  // }

  // Future changedContractorToken(BuildContext context) async {
  //   await flutterSecureStorage.write(key: "role", value: "contractor");
  //   String? token = await flutterSecureStorage.read(key: "token_contractor");
  //   dio.options.headers['authorization'] = "Bearer $token";
  //   dio.options.baseUrl = "https://dev.gservice-co.kz/api/business/";
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const BusinessBottomTab()),
  //       (route) => false);
  // }
}

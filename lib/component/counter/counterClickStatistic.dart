import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';

Future getCountClickApplication(int id, String type) async {
  Response response = await dio.post("/ad-statistic",
      queryParameters: {"application_id": id, "code_type": type});
  print(response.data);
}

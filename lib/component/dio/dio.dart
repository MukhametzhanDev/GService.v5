import 'package:dio/dio.dart';

String token = '';

Map<String, dynamic> headers = {
  "Accept": "application/json",
  // "Api-Language": ""
};

final dio = Dio(BaseOptions(
    baseUrl: "http://dev.gservice-co.kz/api",
    headers: headers,
    followRedirects: false,
    validateStatus: (status) {
      return status! < 500;
    }));

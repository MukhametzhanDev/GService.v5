import 'package:dio/dio.dart';

String token = '';

Map<String, dynamic> headers = {
  "Accept": "application/json",
  // "Api-Language": ""
};

final dio = Dio(BaseOptions(
    baseUrl: "https://gservice-v5/api",
    headers: headers,
    followRedirects: false,
    validateStatus: (status) {
      return status! < 500;
    }));

import 'package:dio/dio.dart';

String token = '';

Map<String, dynamic> headers = {
  "Accept": "application/json",
  // "Api-Language": ""
};

final dio = Dio(BaseOptions(
    baseUrl: "https://dev.gservice-co.kz/api",
    headers: headers,
    followRedirects: false,
    contentType: 'application/json',
    validateStatus: (status) {
      // if (status! == 401) {
      //   ChangedToken().removeIndividualToken(context);
      // }
      return status! < 500;
    }));

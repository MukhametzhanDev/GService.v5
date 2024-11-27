import 'package:dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';

String token = '';

Map<String, dynamic> headers = {
  "Accept": "application/json",
  "Content-Type": "application/json"
  // "Api-Language": ""
};

final dio = Dio(BaseOptions(
    baseUrl: "https://dev.gservice-co.kz/api",
    headers: headers,
    followRedirects: false,
    validateStatus: (status) {
      // if (status! == 401) {
      //   ChangedToken().removeIndividualToken(context);
      // }
      return status! < 500;
    }));

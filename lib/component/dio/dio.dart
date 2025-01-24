import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gservice5/analytics/event_name.constan.dart';

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

      if (status == 401) {
        final analytics = FirebaseAnalytics.instance;

        analytics.setDefaultEventParameters({
          GAKey.role: null,
        });

        analytics.setUserId(id: null);
      }

      return status! < 500;
    }));

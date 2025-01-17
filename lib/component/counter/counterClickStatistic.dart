import 'package:dio/dio.dart';
import 'package:gservice5/component/dio/dio.dart';

Future getCountClick(int id, String type, bool hasAd) async {
  try {
    String API = "/statistic-ad";
    if (!hasAd) API = "/statistic-application";
    print({"ad_id": id, "code_type": type});
    Response response =
        await dio.post(API, queryParameters: {"ad_id": id, "code_type": type});
    print(response.data);
  } on DioException catch (e) {
    print(e);
  }
}

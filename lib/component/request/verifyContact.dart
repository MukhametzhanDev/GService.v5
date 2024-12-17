import 'package:dio/dio.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class GetContact {
  Future<List> getData(context) async {
    try {
      Response response = await dio.get("/ad-contact");
      if (response.data['success']) {
        return response.data['data'];
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
        return [];
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
      return [];
    }
  }
}

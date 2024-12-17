import 'package:dio/dio.dart';
import 'package:gservice5/component/categories/data/categoriesData.dart';
import 'package:gservice5/component/categories/data/mainPageData.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class GetMainPageData {
  Future<Map> getData(context) async {
    try {
      Response response = await dio.get("/mobile-index");
      if (response.data['success']) {
        MainPageData.data.addAll(response.data['data']);
        CategoriesData.categories.addAll(response.data['data']['categories']);
        return response.data['data'];
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
        return {};
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
      return {};
    }
  }
}

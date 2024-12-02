import 'package:dio/dio.dart';
import 'package:gservice5/component/categories/data/categoriesData.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class GetCategories {
  Future<List> getData(context) async {
    print("asdfasdf");
    try {
      Response response = await dio.get("/categories");
      if (response.data['success']) {
        CategoriesData.categories.addAll(response.data['data']);
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

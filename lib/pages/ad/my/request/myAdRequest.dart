import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class MyAdRequest {
  Future<bool> archivedAd(int adId, BuildContext context) async {
    showModalLoader(context);
    try {
      Response response = await dio.post('/archive/$adId');
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        return true;
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
        return false;
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
      return false;
    }
  }

  Future<bool> deletedAd(int adId, BuildContext context) async {
    showModalLoader(context);
    try {
      Response response = await dio.delete('/ad/$adId');
      Navigator.pop(context);
      if (response.data['success']) {
        return true;
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
        return false;
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
      return false;
    }
  }

  Future restoreAd(int adId, BuildContext context) async {
    showModalLoader(context);
    try {
      Response response = await dio.post('/restore-ad/$adId');
      Navigator.pop(context);
      if (response.data['success']) {
        return true;
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
        return false;
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
      return false;
    }
  }

  Future unZipAd(int adId, BuildContext context) async {
    showModalLoader(context);
    try {
      Response response = await dio.post('/remove-archive/$adId');
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        return true;
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
        return false;
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
      return false;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';

class ChangeRoleRequest {
  Future<List> getRoles() async {
    List roles = [];
    try {
      Response response = await dio.get("/available-roles");
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        roles = response.data['data'];
      }
    } finally {
      return roles;
    }
  }

  Future postData(int roleId, VoidCallback switchRole) async {
    try {
      Response response =
          await dio.post("/change-role", queryParameters: {"role_id": roleId});
      if (response.statusCode == 200 && response.data['success']) {
        switchRole();
      }
    } on DioException catch (e) {
      print(e);
    }
  }
}

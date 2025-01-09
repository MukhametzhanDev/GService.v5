import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/navigation/business/businessBottomTab.dart';
import 'package:gservice5/navigation/customer/customerBottomTab.dart';

class ListRolesModal extends StatefulWidget {
  final String role;
  const ListRolesModal({super.key, required this.role});

  @override
  State<ListRolesModal> createState() => _ListRolesModalState();
}

class _ListRolesModalState extends State<ListRolesModal> {
  bool loader = true;
  List roles = [];

  @override
  void initState() {
    getRoles();
    super.initState();
  }

  void getRoles() async {
    try {
      Response response = await dio.get("/available-roles");
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        roles = response.data['data'];
        if (roles.length == 1) {
          await postData(roles[0]['id']);
        } else {
          loader = false;
        }
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Future postData(int roleId) async {
    try {
      Response response =
          await dio.post("/change-role", queryParameters: {"role_id": roleId});
      if (response.statusCode == 200 && response.data['success']) {
        switchRole();
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void onChangedRole(roleId) async {
    showModalLoader(context);
    await postData(roleId);
    Navigator.pop(context);
    switchRole();
  }

  void switchRole() async {
    if (widget.role == "customer") {
      await const FlutterSecureStorage().write(key: "role", value: "business");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BusinessBottomTab()),
          (route) => false);
    } else if (widget.role == "business") {
      await const FlutterSecureStorage().write(key: "role", value: "customer");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomerBottomTab()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
              title: Text(loader ? "Загрузка данных" : "Роли"),
              automaticallyImplyLeading: false),
          loader
              ? SizedBox(height: 80, child: LoaderComponent())
              : Column(
                  children: roles.map((value) {
                  return ListTile(
                      onTap: () => onChangedRole(value['id']),
                      title: Text(value['title']));
                }).toList()),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

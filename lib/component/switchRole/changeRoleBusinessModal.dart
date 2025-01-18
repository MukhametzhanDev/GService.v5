import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/navigation/customer/customerBottomTab.dart';
import 'package:gservice5/provider/nameCompanyProvider.dart';
import 'package:provider/provider.dart';

class ChangeRoleBusinessModal extends StatefulWidget {
  const ChangeRoleBusinessModal({super.key});

  @override
  State<ChangeRoleBusinessModal> createState() =>
      _ChangeRoleBusinessModalState();
}

class _ChangeRoleBusinessModalState extends State<ChangeRoleBusinessModal> {
  bool loader = true;
  List roles = [];
  Map userData = {};

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    try {
      Response response = await dio.get("/user");
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        userData = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void getRoles() async {
    showModalLoader(context);
    try {
      Response response = await dio.get("/available-roles");
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        roles = response.data['data'];
        await postData(roles[0]['id']);
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

  void switchRole() async {
    Navigator.pop(context);
    await const FlutterSecureStorage().write(key: "role", value: "customer");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CustomerBottomTab()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NameCompanyProvider>(builder: (context, data, child) {
      return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                  title: const Text("Переключить аккаунт?"),
                  centerTitle: false,
                  actions: const [CloseIconButton(iconColor: null, padding: true)],
                  automaticallyImplyLeading: false),
              loader
                  ? Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: const LoaderComponent())
                  : Column(
                      children: [
                        ListTile(
                            title: Text(data.name ?? ""),
                            trailing: SvgPicture.asset("assets/icons/check.svg",
                                color: ColorComponent.blue['500'])),
                        Divider(height: 1, color: ColorComponent.gray['100']),
                        ListTile(
                            onTap: getRoles, title: Text(userData['name'])),
                        Divider(height: 1, color: ColorComponent.gray['100'])
                      ],
                    ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 15),
            ],
          ));
    });
  }
}

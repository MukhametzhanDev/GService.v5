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
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:gservice5/pages/ad/my/request/changeRoleRequest.dart';
import 'package:gservice5/provider/nameCompanyProvider.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

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

  void changeRole() async {
    showModalLoader(context);
    List roles = await ChangeRoleRequest().getRoles();
    await ChangeRoleRequest().postData(roles[0]['id'], switchRole);
  }

  void switchRole() async {
    Navigator.pop(context);
    await const FlutterSecureStorage().write(key: "role", value: "customer");
    context.router.pushAndPopUntil(const CustomerBottomRoute(),
        predicate: (route) => false);
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
                  actions: const [
                    CloseIconButton(iconColor: null, padding: true)
                  ],
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
                            onTap: changeRole, title: Text(userData['name'])),
                        Divider(height: 1, color: ColorComponent.gray['100'])
                      ],
                    ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 15),
            ],
          ));
    });
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/switchRole/listRolesModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class SwitchRoleWidget extends StatefulWidget {
  const SwitchRoleWidget({super.key});

  @override
  State<SwitchRoleWidget> createState() => _SwitchRoleWidgetState();
}

class _SwitchRoleWidgetState extends State<SwitchRoleWidget> {
  Map data = {};
  Map userData = {};
  bool loader = true;
  String? role;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    bool hasToken = await ChangedToken().getToken() != null;
    if (hasToken) {
      role = await ChangedToken().getRole();
      print("role $role");
      try {
        Response response = await dio.get("/user");
        if (response.data['success']) {
          if (response.data['data'] != null) {
            data = response.data['data'];
            if (role == "customer") {
              userData = response.data['data']['company'];
            } else {
              userData = response.data['data'];
            }
          }
          loader = false;
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    } else {
      loader = false;
    }
    setState(() {});
  }

  void showCreateCompany() {
    Navigator.pop(context);
    Navigator.pushNamed(context, "RegistrationBusinessPage");
  }

  void onChangedRole() {
    showModalBottomSheet(
        context: context, builder: (context) => ListRolesModal(role: role!));
  }

  @override
  Widget build(BuildContext context) {
    return loader
        ? Shimmer.fromColors(
            baseColor: const Color(0xffD1D5DB),
            highlightColor: const Color(0xfff4f5f7),
            period: const Duration(seconds: 1),
            child: Container(
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8))))
        : data.isNotEmpty
            ? GestureDetector(
                onTap: onChangedRole,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorComponent.gray['100']),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      CacheImage(
                          url: userData['avatar'],
                          width: 42,
                          height: 42,
                          borderRadius: 50),
                      const Divider(indent: 12),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(
                            "ID: ${userData['id']}",
                            style: TextStyle(
                                fontSize: 13,
                                color: ColorComponent.gray['500']),
                          )
                        ],
                      )),
                      SvgPicture.asset("assets/icons/right.svg")
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: showCreateCompany,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ColorComponent.mainColor),
                        child: const Text("Стать партнером",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SvgPicture.asset("assets/icons/questionOutline.svg"),
                    const Divider(indent: 20)
                  ],
                ),
              );
  }
}

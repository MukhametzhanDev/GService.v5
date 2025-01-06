import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:shimmer/shimmer.dart';

class SwitchRoleWidget extends StatefulWidget {
  const SwitchRoleWidget({super.key});

  @override
  State<SwitchRoleWidget> createState() => _SwitchRoleWidgetState();
}

class _SwitchRoleWidgetState extends State<SwitchRoleWidget> {
  Map data = {};
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
      String API = role == "business" ? "/user" : "/my-company";
      try {
        Response response = await dio.get(API);
        if (response.data['success']) {
          if (response.data['data'] != null) {
            data = response.data['data'];
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

  void switchRole() async {
    if (role == "customer") {
      await const FlutterSecureStorage().write(key: "role", value: "business");
      Navigator.pushReplacementNamed(context, "BusinessBottomTab");
    } else if (role == "business") {
      await const FlutterSecureStorage().write(key: "role", value: "customer");
      Navigator.pushReplacementNamed(context, "CustomerBottomTab");
    }
  }

  void showCreateCompany() {
    Navigator.pop(context);
    Navigator.pushNamed(context, "RegistrationBusinessPage");
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
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8))))
        : data.isNotEmpty
            ? GestureDetector(
                onTap: switchRole,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorComponent.gray['100']),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      CacheImage(
                          url: data['avatar'],
                          width: 42,
                          height: 42,
                          borderRadius: 50),
                      Divider(indent: 12),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['name'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(
                            "ID: ${data['id']}",
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
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ColorComponent.mainColor),
                        child: Text("Стать партнером",
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

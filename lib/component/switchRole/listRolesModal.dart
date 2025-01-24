import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:gservice5/pages/ad/my/request/changeRoleRequest.dart';
import 'package:auto_route/auto_route.dart';

class ListRolesModal extends StatefulWidget {
  final String role;
  const ListRolesModal({super.key, required this.role});

  @override
  State<ListRolesModal> createState() => _ListRolesModalState();
}

class _ListRolesModalState extends State<ListRolesModal> {
  bool loader = true;
  List roles = [];

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    getRoles();
    super.initState();
  }

  void getRoles() async {
    roles = await ChangeRoleRequest().getRoles();
    if (roles.length == 1 && widget.role == "customer") {
      await ChangeRoleRequest().postData(roles[0]['id'], switchRole);
    }
  }

  void onChangedRole(roleId) async {
    showModalLoader(context);
    await ChangeRoleRequest().postData(roleId, switchRole);
    Navigator.pop(context);
  }

  void switchRole() async {
    if (widget.role == "customer") {
      await const FlutterSecureStorage().write(key: "role", value: "business");
      context.router.pushAndPopUntil(const BusinessBottomRoute(),
          predicate: (route) => false);

      analytics.setDefaultEventParameters({GAKey.role: 'business'});
    } else if (widget.role == "business") {
      await const FlutterSecureStorage().write(key: "role", value: "customer");
      context.router.pushAndPopUntil(const CustomerBottomRoute(),
          predicate: (route) => false);
      analytics.setDefaultEventParameters({GAKey.role: 'customer'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
              title: Text(loader ? "Загрузка данных" : "Роли"),
              automaticallyImplyLeading: false),
          loader
              ? const SizedBox(height: 80, child: LoaderComponent())
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

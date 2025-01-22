import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/navigation/business/businessBottomTab.dart';
import 'package:gservice5/navigation/customer/customerBottomTab.dart';
import 'package:gservice5/pages/ad/my/request/changeRoleRequest.dart';

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

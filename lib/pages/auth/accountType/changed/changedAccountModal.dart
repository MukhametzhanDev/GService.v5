import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/switchRole/switchRoleWidget.dart';

class ChangedAccountModal extends StatefulWidget {
  const ChangedAccountModal({super.key});

  @override
  State<ChangedAccountModal> createState() => _ChangedAccountModalState();
}

class _ChangedAccountModalState extends State<ChangedAccountModal> {
  // void onChangedRole() {
  //   Navigator.pop(context);
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) => ListRolesModal(role: "business"));
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text("Переключить аккаунт?"),
                actions: const [
                  CloseIconButton(iconColor: null, padding: true)
                ]),
            body: Column(
              children: [Divider(indent: 14), SwitchRoleWidget()],
            )));
  }
}

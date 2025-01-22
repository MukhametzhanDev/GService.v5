import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ChangedAccountRoleModal extends StatefulWidget {
  const ChangedAccountRoleModal({super.key});

  @override
  State<ChangedAccountRoleModal> createState() =>
      _ChangedAccountRoleModalState();
}

class _ChangedAccountRoleModalState extends State<ChangedAccountRoleModal> {
  // void onChangedRole() {
  //   Navigator.pop(context);
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) => ListRolesModal(role: "business"));
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 190 + MediaQuery.of(context).padding.bottom,
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text("Переключить аккаунт?"),
                centerTitle: false,
                actions: const [
                  CloseIconButton(iconColor: null, padding: true)
                ]),
            body: Column(
              children: [
                ListTile(
                  title: const Text("Mservice"),
                  trailing: SvgPicture.asset("assets/icons/check.svg",
                      color: ColorComponent.blue['500']),
                ),
                ListTile(
                    title: const Text("Mukhametzhan"),
                    subtitle: Text("GService",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorComponent.gray['500']))
                    // trailing: SvgPicture.asset("assets/icons/check.svg",
                    //     color: ColorComponent.blue['500']),
                    )
              ],
            )));
  }
}

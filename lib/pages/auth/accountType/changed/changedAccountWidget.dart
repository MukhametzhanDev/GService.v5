import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/pages/auth/accountType/changed/changedAccountTypePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChangedAccountWidget extends StatefulWidget {
  const ChangedAccountWidget({super.key});

  @override
  State<ChangedAccountWidget> createState() => _ChangedAccountWidgetState();
}

class _ChangedAccountWidgetState extends State<ChangedAccountWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          onTap: () {
            showCupertinoModalBottomSheet(
                context: context, builder: (context) => ChangedAccountType());
          },
          leading: SvgPicture.asset('assets/icons/plus.svg'),
          title: Text("Добавить бизнес аккаунт"))
    ]);
  }
}

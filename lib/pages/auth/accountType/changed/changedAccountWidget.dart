import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          leading: SvgPicture.asset('assets/icons/plus.svg'),
          title: Text("Добавить бизнес аккаунт"))
    ]);
  }
}

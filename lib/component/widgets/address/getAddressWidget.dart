import 'package:flutter/material.dart';
import 'package:gservice5/component/select/selectButton.dart';

class GetAddressWidget extends StatefulWidget {
  const GetAddressWidget({super.key});

  @override
  State<GetAddressWidget> createState() => _GetAddressWidgetState();
}

class _GetAddressWidgetState extends State<GetAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SelectButton(
        title: "Выберите страну",
        onPressed: () {},
      )
    ]);
  }
}

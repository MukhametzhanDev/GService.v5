import 'package:flutter/material.dart';
import 'package:gservice5/component/modal/countries.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GetAddressWidget extends StatefulWidget {
  final void Function() onPressed;
  final Map data;
  final bool showCountry;
  const GetAddressWidget(
      {super.key,
      required this.onPressed,
      required this.data,
      required this.showCountry});

  @override
  State<GetAddressWidget> createState() => _GetAddressWidgetState();
}

class _GetAddressWidgetState extends State<GetAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      widget.showCountry
          ? SelectButton(
              title: widget.data.isEmpty
                  ? "Выберите страну и город"
                  : "${widget.data['country']['title']}, ${widget.data['city']['title']} ",
              active: widget.data.isNotEmpty,
              onPressed: widget.onPressed)
          : SelectButton(
              title: widget.data.isEmpty
                  ? "Выберите город"
                  : "${widget.data['city']['title']} ",
              active: widget.data.isNotEmpty,
              onPressed: widget.onPressed)
      // Divider(indent: 15),
      // SelectButton(title: "Выберите город", onPressed: () {})
    ]);
  }
}

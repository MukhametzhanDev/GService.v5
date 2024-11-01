import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/backIconButton.dart';
import 'package:gservice5/component/modal/countries.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  Map address = {};

  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) =>
            Countries(onPressed: savedAddressData, data: address));
  }

  void savedAddressData(value) {
    if (value != null) {
      setState(() {
        address = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Регистрация"), leading: BackIconButton()),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            GestureDetector(
              onTap: showModal,
              child: Container(
                height: 48,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Color(0xffF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Color(0xffE5E5EA))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("Казахстан",
                          style: TextStyle(
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis)),
                    ),
                    SvgPicture.asset('assets/icons/down.svg')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

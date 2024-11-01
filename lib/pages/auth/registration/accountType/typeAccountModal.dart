import 'package:flutter/material.dart';
import 'package:gservice5/component/button/closeIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/auth/registration/accountType/infoTypeAccountModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TypeAccountModal extends StatefulWidget {
  const TypeAccountModal({super.key});

  @override
  State<TypeAccountModal> createState() => _TypeAccountModalState();
}

class _TypeAccountModalState extends State<TypeAccountModal> {
  List data = [
    {
      "title": "Физическое лицо",
      "desc": "Публикация объявленийот частного лица",
      "type": "individual"
    },
    {
      "title": "Компания заказчик",
      "desc": "Публикация объявленийот частного лица",
      "type": "customer"
    },
    {
      "title": "Компания исполнитель",
      "desc": "Публикация объявленийот частного лица",
      "type": "contractor"
    },
  ];

  void showInfoTypeAccount(Map data) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => InfoTypeAccountModal(data: data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: Container(),
          leadingWidth: 0,
          title: Text("Тип личного кабинета"),
          actions: [CloseIconButton(iconColor: null, padding: true)]),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: data.map((value) {
              return GestureDetector(
                onTap: () {
                  showInfoTypeAccount(value);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1, color: Color(0xffD1D5DB))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1, color: Color(0xffD1D5DB)))),
                      Divider(indent: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16)),
                          Divider(height: 4),
                          Text(value['desc'],
                              style:
                                  TextStyle(color: ColorComponent.gray['500']))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}

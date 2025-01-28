import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/select/selectVerifyData.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/component/widgets/checkBox/checkBoxWidget.dart';
import 'package:gservice5/pages/ad/package/listPackagePage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/profile/contacts/addContactModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditContactMyAdPage extends StatefulWidget {
  final Map data;
  const EditContactMyAdPage({super.key, required this.data});

  @override
  State<EditContactMyAdPage> createState() => _EditContactMyAdPageState();
}

class _EditContactMyAdPageState extends State<EditContactMyAdPage> {
  Map city = {};
  List contacts = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    city = widget.data['city'];
    try {
      Response response = await dio.get("/ad-contact");
      if (response.data['success']) {
        contacts = checkActiveContacts(response.data['data']);
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  List getPhones() {
    List value = contacts
        .where((value) => value['active'])
        .map((value) => value['phone'])
        .toList();
    return value;
  }

  void verifyData() {
    if (city.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните строку 'Город'", context);
    } else if (contacts.isEmpty) {
      SnackBarComponent()
          .showErrorMessage("Заполните строку 'Телефоны'", context);
    } else {}
  }

  List checkActiveContacts(List data) {
    List adContacts = widget.data['phones'];
    if (adContacts.isNotEmpty) {
      for (var value in data) {
        value['active'] = adContacts.contains(value['phone']);
      }
    }
    return data;
  }

  void showContactPage() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => AddContactModal(data: contacts)).then((value) {
      if (value != null) {
        value['active'] = true;
        contacts.add(value);
        setState(() {});
      }
    });
  }

  void onChangedPhone(Map value) {
    bool active = value['active'] ?? false;
    if (active) {
      value['active'] = false;
    } else {
      value['active'] = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackTitleButton(title: "Редактировать контакты"),
          leadingWidth: 250),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Город",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 12),
            SelectVerifyData(
                title: "Город",
                value: city,
                onChanged: (value) {
                  city = value;
                  setState(() {});
                },
                pagination: false,
                api: "/cities?country_id=191",
                showErrorMessage: ""),
            const Divider(height: 24),
            const Text("Телефоны",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 12),
            contacts.isEmpty
                ? Container()
                : Column(
                    children: contacts.map((value) {
                    bool active = value['active'] ?? false;
                    return GestureDetector(
                      onTap: () => onChangedPhone(value),
                      child: Container(
                        height: 52,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xfff4f5f7)))),
                        child: Row(
                          children: [
                            CheckBoxWidget(active: active),
                            const Divider(indent: 16),
                            Text(
                                "+${value['country']['phone_code']}${value['phone']}")
                          ],
                        ),
                      ),
                    );
                    // return ListTile(
                    //     leading: CheckBoxWidget(active: false),
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => EditContactMyAdPage()));
                    //     },
                    //     title: const Text("+7 747 265 23 38",
                    //         style: TextStyle(fontSize: 14)));
                  }).toList()),
            const Divider(height: 8),
            TextButton(
                onPressed: showContactPage,
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/plusBlue.svg'),
                    const SizedBox(width: 12),
                    Text("Добавить контакты",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorComponent.blue['500']))
                  ],
                )),
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Редактировать")),
    );
  }
}

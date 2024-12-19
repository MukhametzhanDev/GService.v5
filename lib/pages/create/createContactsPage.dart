import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/map/getMapAddressPage.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/select/selectVerifyData.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/component/widgets/checkBox/checkBoxWidget.dart';
import 'package:gservice5/pages/profile/contacts/addContactModal.dart';
import 'package:gservice5/pages/profile/contacts/addContactsPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateContactsPage extends StatefulWidget {
  const CreateContactsPage({super.key});

  @override
  State<CreateContactsPage> createState() => _CreateContactsPageState();
}

class _CreateContactsPageState extends State<CreateContactsPage> {
  Map address = {};
  Map city = {};
  List contacts = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/ad-contact");
      if (response.data['success']) {
        contacts = allActived(response.data['data']);
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  List allActived(List data) {
    data.forEach((value) => value['active'] = true);
    return data;
  }

  void showGetAddressPage() {
    if (city.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните строку 'Город'", context);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GetMapAddressPage(
                  onSavedData: (value) {
                    address = value;
                    setState(() {});
                  },
                  cityData: city)));
    }
  }

  void showContactPage() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => AddContactModal(data: contacts)).then((value) {
      if (value != null) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text("Контактная информация",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
            const Divider(height: 24),
            Text("Город и адрес",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 12),
            SelectVerifyData(
                title: "Город",
                onChanged: (value) {
                  city = value;
                  setState(() {});
                },
                pagination: false,
                api: "/cities?country_id=191",
                showErrorMessage: ""),
            const Divider(),
            SelectButton(
                title: address.isEmpty ? "Введите адрес" : address['address'],
                active: address.isNotEmpty,
                onPressed: showGetAddressPage),
            const Divider(height: 24),
            Text("Телефоны",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 12),
            Column(
                children: contacts.map((value) {
              bool active = value['active'] ?? false;
              return GestureDetector(
                onTap: () => onChangedPhone(value),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xfff4f5f7)))),
                  child: Row(
                    children: [
                      CheckBoxWidget(active: active),
                      Divider(indent: 16),
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
              //               builder: (context) => CreateContactsPage()));
              //     },
              //     title: const Text("+7 747 265 23 38",
              //         style: TextStyle(fontSize: 14)));
            }).toList()),
            Divider(height: 8),
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
              onPressed: () {},
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Подать объявление")),
    );
  }
}

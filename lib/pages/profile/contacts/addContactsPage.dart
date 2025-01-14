import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/profile/contacts/countryCodeListModal.dart';
import 'package:gservice5/pages/profile/contacts/requestContact.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  List countriesData = [];
  List phoneNumber = [];
  bool loader = true;
  List<TextEditingController> controllers = [];

  final analytics = GetIt.I<FirebaseAnalytics>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    countriesData = await RequestContact().getCountries();
    await getDataContact();
    loader = false;
    setState(() {});
  }

  Future getDataContact() async {
    try {
      Response response = await dio.get("/ad-contact");
      if (response.data['success']) {
        formattedData(response.data['data']);
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void formattedData(List data) {
    phoneNumber.clear();
    controllers.clear();

    for (var value in data) {
      if (value['social_network'] == null) {
        phoneNumber.add({
          "value": value['phone'] ?? "",
          "country": value['country'] ?? countriesData[0],
        });
        controllers.add(TextEditingController(
          text: value['phone'] ?? "",
        ));
      }
    }

    if (phoneNumber.isEmpty) {
      phoneNumber.add({"value": "", "country": countriesData[0]});
      controllers.add(TextEditingController(text: ""));
    }

    setState(() {});
  }

  void addNewPhoneData() {
    closeKeyboard();
    if (phoneNumber.length != 4) {
      if (phoneNumber.isEmpty) {
        phoneNumber.add({"value": "", "country": countriesData[0]});
      } else {
        Map value = phoneNumber[phoneNumber.length - 1];
        // if (value['value'].length == value['country']['phone_length']) {
        phoneNumber.add({"value": "", "country": countriesData[0]});
        // } else {
        // SnackBarComponent().showErrorMessage("Заполните строки", context);
        // }
      }
    }
  }

  void showCountryCodes(Map value) {
    showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => CountryCodeListModal(data: countriesData))
        .then((currencyValue) {
      if (currencyValue != null) {
        value['country'] = currencyValue;
        setState(() {});
      }
    });
  }

  void verifyData() {
    for (var value in phoneNumber) {
      if (value['value'] == null || value['value'].isEmpty) {
        SnackBarComponent().showErrorMessage(
            "Введите номер телефона перед отправкой.", context);
        return;
      }
    }
    postData();

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.screenName: GAParams.addContactsPage,
      GAKey.buttonName: GAParams.btnMyContactSave
    }).catchError((onError) => debugPrint(onError));
  }

  List<Map<String, String>> formattedPhoneParams() {
    List<Map<String, String>> param = [];
    for (Map value in phoneNumber) {
      param.add({
        "value": value['value'].toString(),
        "country_id": value['country']['id'].toString()
      });
    }

    return param;
  }

  void postData() async {
    List<Map<String, String>> paramPhone = formattedPhoneParams();
    print(paramPhone);
    showModalLoader(context);
    try {
      Response response =
          await dio.post("/ad-contact", data: {"phone": paramPhone});
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        Navigator.pop(context, response.data['data']);
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Контакты"), leading: const BackIconButton()),
        body: loader
            ? const LoaderComponent()
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Добавьте способы связи они будут автоматически видны на всех ваших объявлениях",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorComponent.gray['500'])),
                      const SizedBox(height: 16),
                      const Text("Телефонные номера",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      const SizedBox(height: 12),
                      Column(
                          children: phoneNumber.map((value) {
                        int index = phoneNumber.indexOf(value);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  autofillHints: const [
                                    AutofillHints.telephoneNumber
                                  ],
                                  keyboardType: TextInputType.number,
                                  maxLength: value['country']['phone_length'],
                                  onChanged: (phoneValue) {
                                    setState(() {
                                      phoneNumber[index]['value'] = phoneValue;
                                    });
                                    if (phoneValue.length ==
                                        value['country']['phone_length']) {
                                      closeKeyboard();
                                    }
                                  },
                                  initialValue: value['value'],
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                      counterStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: ColorComponent.gray['500']),
                                      helperStyle: TextStyle(
                                          fontSize: 14,
                                          color: ColorComponent.gray['500']),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                              minHeight: 42, maxHeight: 50),
                                      prefixIcon: Container(
                                        height: 54,
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: TextButton(
                                            onPressed: () {
                                              showCountryCodes(value);
                                            },
                                            style: TextButton.styleFrom(
                                                side: const BorderSide(
                                                    width: 1,
                                                    color: Color(0xffe5e7eb)),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8)))),
                                            child: Container(
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  color: ColorComponent
                                                      .gray['100'],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8))),
                                              alignment: Alignment.center,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.network(
                                                        value['country']
                                                            ['flag'],
                                                        width: 18),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                        " +${value['country']['phone_code']}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    const SizedBox(width: 8),
                                                    SvgPicture.asset(
                                                        'assets/icons/down.svg')
                                                  ]),
                                            )),
                                      )),
                                ),
                              ),
                              index != 0
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              phoneNumber.removeAt(index);
                                            });
                                            print(phoneNumber);
                                          },
                                          icon: SvgPicture.asset(
                                              'assets/icons/trash.svg')),
                                    )
                                  : Container()
                            ],
                          ),
                        );
                      }).toList()),
                      phoneNumber.length == 4
                          ? Container()
                          : TextButton(
                              onPressed: () {
                                addNewPhoneData();
                                setState(() {});
                                analytics.logEvent(
                                    name: GAEventName.buttonClick,
                                    parameters: {
                                      GAKey.screenName:
                                          GAParams.addContactsPage,
                                      GAKey.buttonName:
                                          GAParams.txtbtnMyContact,
                                    }).catchError(
                                    (onError) => debugPrint(onError));
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/icons/plusBlue.svg'),
                                  const SizedBox(width: 12),
                                  Text("Добавить номер телефона",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorComponent.blue['500']))
                                ],
                              )),
                      const SizedBox(height: 16),
                    ]),
              ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
          onPressed: verifyData,
          title: "Сохранить",
          padding: const EdgeInsets.symmetric(horizontal: 16),
        )),
      ),
    );
  }
}

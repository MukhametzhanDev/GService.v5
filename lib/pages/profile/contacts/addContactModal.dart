import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/profile/contacts/countryCodeListModal.dart';
import 'package:gservice5/pages/profile/contacts/requestContact.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddContactModal extends StatefulWidget {
  final List data;
  const AddContactModal({super.key, required this.data});

  @override
  State<AddContactModal> createState() => _AddContactModalState();
}

class _AddContactModalState extends State<AddContactModal> {
  String phoneNumber = "";
  Map currentCountry = {};
  List countriesData = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    countriesData = await RequestContact().getCountries();
    currentCountry = countriesData[0];
    loader = false;
    setState(() {});
  }

  void verifyData() async {
    if (phoneNumber.length == currentCountry['phone_length']) {
      await postData();
    } else {
      SnackBarComponent()
          .showErrorMessage("Неправильный номер телефона", context);
    }
  }

  Future postData() async {
    List<Map<String, String>> param = formattedPhoneParams();
    print(param);
    showModalLoader(context);
    try {
      Response response = await dio.post("/ad-contact", data: {"phone": param});
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        Navigator.pop(context, getLastMap(response.data['data']));
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  Map getLastMap(List value) {
    return value.last;
  }

  List<Map<String, String>> formattedPhoneParams() {
    List<Map<String, String>> param = [];
    for (Map value in widget.data) {
      param.add({
        "value": value['phone'].toString(),
        "country_id": value['country']['id'].toString()
      });
    }
    Map<String, String> value = {
      "value": phoneNumber,
      "country_id": currentCountry['id'].toString()
    };
    param.add(value);
    return param;
  }

  void showCountryCodes() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => CountryCodeListModal()).then((currencyValue) {
      if (currencyValue != null) {
        currentCountry = currencyValue;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210 + MediaQuery.of(context).viewInsets.bottom,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Добавить конакты"),
          actions: const [CloseIconButton(iconColor: null, padding: true)],
        ),
        body: loader
            ? const LoaderComponent()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12))),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      keyboardType: TextInputType.number,
                      maxLength: currentCountry['phone_length'],
                      autofocus: true,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          counterStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: ColorComponent.gray['500']),
                          helperStyle: TextStyle(
                              fontSize: 14, color: ColorComponent.gray['500']),
                          prefixIconConstraints: const BoxConstraints(
                              minHeight: 42, maxHeight: 50),
                          prefixIcon: Container(
                            height: 54,
                            padding: const EdgeInsets.only(right: 16.0),
                            child: TextButton(
                                onPressed: () {
                                  showCountryCodes();
                                },
                                style: TextButton.styleFrom(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xffe5e7eb)),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomLeft: Radius.circular(8)))),
                                child: Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: ColorComponent.gray['100'],
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8))),
                                  alignment: Alignment.center,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.network(
                                            currentCountry['flag'],
                                            width: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                            " +${currentCountry['phone_code']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 8),
                                        SvgPicture.asset(
                                            'assets/icons/down.svg')
                                      ]),
                                )),
                          )),
                    ),
                    const Divider(height: 15),
                    SizedBox(
                        height: 48,
                        child:
                            Button(onPressed: verifyData, title: "Подтвердить"))
                  ],
                ),
              ),
      ),
    );
  }
}

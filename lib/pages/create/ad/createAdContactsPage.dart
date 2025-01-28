import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:gservice5/localization/extensions/context_extension.dart';

class CreateAdContactsPage extends StatefulWidget {
  final void Function() previousPage;
  const CreateAdContactsPage({super.key, required this.previousPage});

  @override
  State<CreateAdContactsPage> createState() => _CreateAdContactsPageState();
}

class _CreateAdContactsPageState extends State<CreateAdContactsPage> {
  Map city = {};
  List contacts = [];
  bool loader = true;
  bool loaderUser = true;

  @override
  void initState() {
    getData();
    getUserData();
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

  Future getUserData() async {
    try {
      Response response = await dio.get("/user");
      if (response.data['success']) {
        city = response.data['data']['city'];
      }
    } catch (e) {}
    loaderUser = false;
    setState(() {});
  }

  FormData getFormData() {
    CreateData.characteristic
        .removeWhere((key, value) => value is Map<String, dynamic>);
    CreateData.data.removeWhere((key, value) => value is Map<String, dynamic>);
    List phones = getPhones();
    FormData formData = FormData.fromMap({
      ...CreateData.data,
      "characteristic": CreateData.characteristic,
      "city_id": city['id'],
      "phones": phones,
      "country_id": 1
    }, ListFormat.multiCompatible);
    return formData;
  }

  Future postData() async {
    print(getFormData().fields);
    showModalLoader(context);
    try {
      Response response = await dio.post("/ad", data: getFormData());
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        CreateData.data.clear();
        CreateData.images.clear();
        CreateData.characteristic.clear();
        Navigator.pop(context);
        Navigator.pop(context, "ad");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListPackagePage(
                    categoryId: response.data['data']['category']['id'],
                    adId: response.data['data']['id'],
                    goBack: false)));
      } else {
        Navigator.pop(context);
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e.response);
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
    } else {
      postData();
    }
  }

  List allActived(List data) {
    for (var value in data) {
      value['active'] = true;
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
            const Divider(height: 12),
            Text(context.localizations.city,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 12),
            loaderUser
                ? Container()
                : SelectVerifyData(
                    title: context.localizations.city,
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
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1, color: ColorComponent.gray['200']!)),
                    child: Text("У все нет сохраненные контакты"))
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
                    //               builder: (context) => CreateAdContactsPage()));
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
              title: "Подать объявление")),
    );
  }
}

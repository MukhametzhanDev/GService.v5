import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/getImage/getLogoWidget.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/modal/countries.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/my/request/changeRoleRequest.dart';
import 'package:gservice5/pages/auth/registration/business/getActivityBusinessPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegistrationBusinessPage extends StatefulWidget {
  const RegistrationBusinessPage({super.key});

  @override
  State<RegistrationBusinessPage> createState() =>
      _RegistrationBusinessPageState();
}

class _RegistrationBusinessPageState extends State<RegistrationBusinessPage> {
  Map currentCity = {};
  Map currentCountry = {};
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController identifierEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();
  String imagePath = "";

  @override
  void dispose() {
    nameEditingController.dispose();
    identifierEditingController.dispose();
    descEditingController.dispose();
    super.dispose();
  }

  Future postImage() async {
    showModalLoader(context);
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imagePath,
            filename: imagePath.split('/').last)
      });
      Response response = await dio.post("/image/avatar", data: formData);
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        postData(response.data['data']);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  Future postData(String url) async {
    showModalLoader(context);
    try {
      Map<String, dynamic> param = {
        "name": nameEditingController.text,
        "city_id": currentCity['id'],
        "country_id": currentCountry['id'],
        "avatar": url,
        "identifier": identifierEditingController.text,
        "description": descEditingController.text
      };
      Response response = await dio.post("/company", data: param);
      print(response.data);
      if (response.statusCode == 200 && response.data['success']) {
        List roles = await ChangeRoleRequest().getRoles();
        await ChangeRoleRequest().postData(roles[0]['id'], () {});
        await switchRole();
      } else {
        Navigator.pop(context);
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  Future switchRole() async {
    await const FlutterSecureStorage().write(key: "role", value: "business");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const GetActivityBusinessPage()),
        (route) => false);
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String indentifier = identifierEditingController.text.trim();
    // String desc = descEditingController.text.trim();
    if (imagePath.isEmpty) {
      SnackBarComponent()
          .showErrorMessage("Загрузите логотип компании", context);
    } else {
      if (name.isEmpty || indentifier.isEmpty
          // || desc.isEmpty
          ) {
        SnackBarComponent().showErrorMessage("Заполните все строки", context);
      } else {
        if (currentCountry.isEmpty || currentCity.isEmpty) {
          SnackBarComponent()
              .showErrorMessage("Заполните страну и город", context);
        } else {
          postImage();
        }
      }
    }
  }

  void showCityModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Cities(
            onPressed: savedCurrentCity, countryId: currentCountry['id']));
  }

  void showCountryModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) =>
            Countries(onPressed: savedCurrentCity, data: const {}));
  }

  void savedCurrentCity(value) {
    setState(() {
      currentCity = value['city'];
      currentCountry = value['country'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
            leading: const BackTitleButton(title: "Данные компании"),
            leadingWidth: 200),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            GetLogoWidget(onChanged: (path) {
              imagePath = path;
              setState(() {});
            }),
            const Divider(height: 24),
            SelectButton(
                title: currentCity.isNotEmpty
                    ? currentCity['title']
                    : "Выберите страну и город",
                active: currentCity.isNotEmpty,
                onPressed: showCountryModal),
            // const Divider(indent: 8),
            // SelectButton(
            //     title: currentCity.isNotEmpty
            //         ? currentCity['title']
            //         : "Выберите город",
            //     active: currentCity.isNotEmpty,
            //     onPressed: showCityModal),
            const Divider(indent: 8),
            TextField(
                controller: nameEditingController,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(hintText: "Название компании")),
            const Divider(indent: 8),
            TextField(
                controller: identifierEditingController,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: InputDecoration(
                    hintText: "БИН",
                    helperStyle: TextStyle(color: ColorComponent.gray['500']))),
            const Divider(indent: 8),
            TextField(
                controller: descEditingController,
                decoration: InputDecoration(
                    hintText: "Описание вашей компании",
                    helperStyle: TextStyle(color: ColorComponent.gray['500'])),
                style: const TextStyle(fontSize: 14),
                maxLength: 200,
                maxLines: 8,
                minLines: 4),
          ]),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: () => verifyData(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                title: "Подтвердить")),
      ),
    );
  }
}

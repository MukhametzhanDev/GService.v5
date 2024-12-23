import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/getImage/getLogoWidget.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChangeContractorProfilePage extends StatefulWidget {
  final Map data;
  const ChangeContractorProfilePage({super.key, required this.data});

  @override
  State<ChangeContractorProfilePage> createState() =>
      _ChangeContractorProfilePageState();
}

class _ChangeContractorProfilePageState extends State<ChangeContractorProfilePage> {
  Map currentCity = {};
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController identifierEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();
  String imagePath = "";
  String imageUrl = "";
  Map<String, dynamic> param = {};

  @override
  void initState() {
    currentCity = widget.data['city'];
    nameEditingController.text = widget.data['name'];
    identifierEditingController.text = widget.data['identifier'];
    descEditingController.text = widget.data['description'];
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    identifierEditingController.dispose();
    super.dispose();
  }

  Future postImage() async {
    if (imagePath == "") {
      postData();
    } else {
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
          param.addAll({"avatar": response.data['data']});
          postData();
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showServerErrorMessage(context);
      }
    }
  }

  Future postData() async {
    showModalLoader(context);
    try {
      param.addAll({
        "role": "customer",
        "name": nameEditingController.text,
        "city_id": currentCity['id'],
        "identifier": identifierEditingController.text,
        "description": descEditingController.text,
        "email": widget.data['email']
      });
      Response response = await dio.put("/company", data: param);
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        Navigator.pop(context, response.data['data']);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String indentifier = identifierEditingController.text.trim();
    String desc = descEditingController.text.trim();
    if (currentCity.isEmpty ||
        name.isEmpty ||
        indentifier.isEmpty ||
        desc.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      if (indentifier.length == 12) {
        postImage();
      } else {
        SnackBarComponent().showErrorMessage("Неправильный БИН", context);
      }
    }
  }

  void showCityModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Cities(
            onPressed: savedcurrentCity, countryId: widget.data['country_id']));
  }

  void savedcurrentCity(value) {
    setState(() {
      currentCity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
            centerTitle: false,
            leading: const BackIconButton(),
            title: const Text("Изменить данные компании")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            GetLogoWidget(
                imageUrl: widget.data['avatar'],
                onChanged: (path) {
                  imagePath = path;
                  setState(() {});
                }),
            const Divider(height: 24),
            SelectButton(
                title: currentCity.isNotEmpty
                    ? currentCity['title']
                    : "Выберите город",
                active: currentCity.isNotEmpty,
                onPressed: showCityModal),
            const Divider(indent: 8),
            TextField(
                controller: nameEditingController,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Название компании")),
            const Divider(indent: 8),
            TextField(
                controller: identifierEditingController,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: InputDecoration(
                    hintText: "БИН",
                    helperStyle: TextStyle(color: ColorComponent.gray['500']))),
            const Divider(),
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
                title: "Изменить")),
      ),
    );
  }
}

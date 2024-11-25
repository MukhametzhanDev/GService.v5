import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/getImage/getLogoWidget.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/select/selectButton.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChangeIndividualProfilePage extends StatefulWidget {
  final Map data;
  const ChangeIndividualProfilePage({super.key, required this.data});

  @override
  State<ChangeIndividualProfilePage> createState() =>
      _ChangeIndividualProfilePageState();
}

class _ChangeIndividualProfilePageState
    extends State<ChangeIndividualProfilePage> {
  Map currentCity = {};
  TextEditingController nameEditingController = TextEditingController();
  String imagePath = "";
  String imageUrl = "";
  Map<String, dynamic> param = {};

  @override
  void initState() {
    currentCity = widget.data['city'];
    nameEditingController.text = widget.data['name'];
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
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
        "name": nameEditingController.text,
        "city_id": currentCity['id'],
      });
      Response response = await dio.put("/user", data: param);
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
    if (currentCity.isEmpty || name.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      postImage();
    }
  }

  void showCityModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Cities(
            onPressed: savedcurrentCity,
            countryId: widget.data['country']['id']));
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
            leadingWidth: MediaQuery.of(context).size.width - 100,
            leading: BackTitleButton(
                title: "Изменить данные",
                onPressed: () => Navigator.pop(context))),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            GetLogoWidget(
                role: "individual",
                imageUrl: widget.data['avatar'],
                onChanged: (path) {
                  imagePath = path;
                  setState(() {});
                }),
            Divider(height: 24),
            SelectButton(
                title: currentCity.isNotEmpty
                    ? currentCity['title']
                    : "Выберите город",
                active: currentCity.isNotEmpty,
                onPressed: showCityModal),
            Divider(indent: 8),
            TextField(
                controller: nameEditingController,
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Название компании")),
          ]),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: () => verifyData(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                title: "Изменить")),
      ),
    );
  }
}

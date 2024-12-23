import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/select/selectVerifyData.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/profile/contacts/addContactModal.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateApplicationContactsPage extends StatefulWidget {
  const CreateApplicationContactsPage({super.key});

  @override
  State<CreateApplicationContactsPage> createState() =>
      _CreateApplicationContactsPageState();
}

class _CreateApplicationContactsPageState
    extends State<CreateApplicationContactsPage> {
  Map city = {};
  bool loader = true;
  bool loaderUser = true;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future getUserData() async {
    try {
      Response response = await dio.get("/user");
      if (response.data['success'] && response.statusCode == 200) {
        city = response.data['data']['city'];
        nameEditingController.text = response.data['data']['name'];
        phoneEditingController.text = maskFormatter
            .maskText(response.data['data']['phone'].toString().substring(1));
      }
    } catch (e) {}
    loaderUser = false;
    setState(() {});
  }

  Future postData() async {
    showModalLoader(context);
    CreateData.data.removeWhere((key, value) => value is Map<String, dynamic>);
    print(CreateData.data);
    try {
      Response response = await dio.post("/application", data: CreateData.data);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        CreateData.data.clear();
        CreateData.images.clear();
        Navigator.pop(context, "application");
        Navigator.pop(context, "application");
        Navigator.pop(context, "application");
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e.response);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    if (nameEditingController.text.trim().isEmpty) {
      SnackBarComponent().showErrorMessage("Введите имя", context);
    } else if (phoneEditingController.text.length < 18) {
      SnackBarComponent().showErrorMessage("Введите номер телефона", context);
    } else if (city.isEmpty) {
      SnackBarComponent().showErrorMessage("Выберите город", context);
    } else {
      CreateData.data.addAll({
        "name": nameEditingController.text,
        "phone": getIntComponent(phoneEditingController.text).toString(),
        "city_id": city['id'],
        "country_id": 1
      });
      postData();
    }
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
            const Text("Имя",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 8),
            AutofillGroup(
                child: TextField(
                    autofillHints: const [AutofillHints.name],
                    controller: nameEditingController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(hintText: "Имя"))),
            const Divider(height: 16),
            const Text("Номер телефона",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 8),
            AutofillGroup(
              child: TextField(
                  controller: phoneEditingController,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14),
                  decoration:
                      const InputDecoration(hintText: "Номер телефона")),
            ),
            const Divider(height: 16),
            const Text("Город",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 8),
            loaderUser
                ? Container()
                : SelectVerifyData(
                    title: "Город",
                    value: city,
                    onChanged: (value) {
                      city = value;
                      setState(() {});
                    },
                    pagination: false,
                    api: "/cities?country_id=191",
                    showErrorMessage: "")
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Подать заявку")),
    );
  }
}

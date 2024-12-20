import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ContactCreateApplicationPage extends StatefulWidget {
  final void Function() nextPage;
  const ContactCreateApplicationPage({super.key, required this.nextPage});

  @override
  State<ContactCreateApplicationPage> createState() =>
      _ContactCreateApplicationPageState();
}

class _ContactCreateApplicationPageState
    extends State<ContactCreateApplicationPage> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    bool token = await ChangedToken().getToken() != null;
    if (token) {
      try {
        Response response = await dio.get("/user");
        if (response.data['success'] && response.statusCode == 200) {
          nameEditingController.text = response.data['data']['name'];
          phoneEditingController.text =
              maskFormatter.maskText(response.data['data']['phone']);
          setState(() {});
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    phoneEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String phone = phoneEditingController.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      savedData();
    }
  }

  void savedData() {
    CreateData.data.addAll({
      "name": nameEditingController.text,
      "phone": getIntComponent(phoneEditingController.text).toString()
    });
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          AutofillGroup(
              child: TextField(
                  autofillHints: const [AutofillHints.name],
                  controller: nameEditingController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(hintText: "Имя"))),
          const Divider(height: 24),
          AutofillGroup(
            child: TextField(
                controller: phoneEditingController,
                autofillHints: const [AutofillHints.telephoneNumber],
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(hintText: "Номер телефона")),
          )
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}

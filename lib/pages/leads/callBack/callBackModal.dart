import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CallBackModal extends StatefulWidget {
  final int id;
  const CallBackModal({super.key, required this.id});

  @override
  State<CallBackModal> createState() => _CallBackModalState();
}

class _CallBackModalState extends State<CallBackModal> {
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/user");
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        nameEditingController.text = response.data['data']['name'];
        phoneEditingController.text =
            maskFormatter.maskText(response.data['data']['phone'] ?? "");
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    phoneEditingController.dispose();
    nameEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String name = nameEditingController.text.trim();
    String phone = phoneEditingController.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else if (phone.length == 18) {
      postData();
    } else {
      SnackBarComponent().showErrorMessage("Номер телефона указан неверно", context);
    }
  }

  Future postData() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/company-callback", queryParameters: {
        "company_id": widget.id,
        "name": nameEditingController.text,
        "phone": getIntComponent(phoneEditingController.text)
      });
      Navigator.pop(context);
      if (response.statusCode == 200 && response.data['success']) {
        Navigator.pop(context);
        SnackBarComponent()
            .showDoneMessage("С вами скоро свяжутся менеджеры", context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 310 + MediaQuery.of(context).viewInsets.bottom,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text("Заказать обратный звонок"),
            actions: [CloseIconButton(iconColor: null, padding: true)],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Оставьте свои контакты, и менеджер компании свяжется с вами.",
                    style: TextStyle(fontSize: 15)),
                Divider(indent: 12),
                PhoneTextField(
                    textEditingController: phoneEditingController,
                    autofocus: true,
                    onSubmitted: () {}),
                Divider(indent: 12),
                TextField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontSize: 14, height: 1.1),
                    decoration: const InputDecoration(hintText: "Имя"),
                    controller: nameEditingController),
                Divider(indent: 12),
                SizedBox(
                  height: 46,
                  child: Button(onPressed: verifyData, title: "Отправить"),
                )
              ],
            ),
          ),
        ));
  }
}

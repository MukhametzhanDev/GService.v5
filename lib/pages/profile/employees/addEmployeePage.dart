import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/phoneTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/data/message/messageInviteApp.dart';
import 'package:gservice5/provider/nameCompanyProvider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  TextEditingController textEditingController = TextEditingController();
  bool loader = false;
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  void existsUser() async {
    loader = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2), () {});
    loader = false;
    setState(() {});

    // try {
    //   Response response = await dio.get("");
    // } catch (e) {
    //   SnackBarComponent().showNotGoBackServerErrorMessage(context);
    // }
  }

  void verifyPhone() {
    if (textEditingController.text.length == 18) {
      existsUser();
    } else {
      SnackBarComponent().showErrorMessage("Заполните номер телефона", context);
    }
  }

  void sendMessage() async {
    String companyName =
        Provider.of<NameCompanyProvider>(context, listen: false).nameValue;
    await MessageInviteApp().sendCompanyInvite(companyName);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackTitleButton(title: "Добавить сотрудника"),
          leadingWidth: 300),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Телефон номер сотудника", style: TextStyle(fontSize: 13)),
            const Divider(height: 6),
            SizedBox(
              height: 48,
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter],
                onChanged: (value) {
                  if (value.length == 18) {
                    closeKeyboard();
                    existsUser();
                  }
                },
                style: const TextStyle(fontSize: 14, height: 1.1),
                onSubmitted: (value) {},
                controller: textEditingController,
                decoration: const InputDecoration(hintText: "+7"),
              ),
            ),
            const Divider(height: 12),
            loader
                ? Shimmer.fromColors(
                    baseColor: const Color(0xffD1D5DB),
                    highlightColor: const Color(0xfff4f5f7),
                    period: const Duration(seconds: 1),
                    child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10))))
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      children: [
                        CacheImage(
                            url:
                                "https://images.unsplash.com/photo-1737071371043-761e02b1ef95?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzfHx8ZW58MHx8fHx8",
                            width: 40,
                            height: 40,
                            borderRadius: 30),
                        Divider(indent: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Казыбек Шалабаев",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                            Divider(height: 2),
                            Text("ID 123", style: TextStyle(fontSize: 12))
                          ],
                        ))
                      ],
                    ),
                  ),
            const Divider(height: 12),
            GestureDetector(
              onTap: sendMessage,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Пользователь не найден",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      const Divider(height: 10),
                      const Text("Пригласите сотрудника в GService.kz"),
                      const Divider(height: 12),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ColorComponent.blue['500']),
                        child: const Text("Пригласить сотрудника",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyPhone,
              title: "Добавить",
              padding: const EdgeInsets.symmetric(horizontal: 15))),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class DeleteAccountModal extends StatefulWidget {
  const DeleteAccountModal({super.key});

  @override
  State<DeleteAccountModal> createState() => _DeleteAccountModalState();
}

class _DeleteAccountModalState extends State<DeleteAccountModal> {
  void deleteAccount() async {
    showModalLoader(context);
    try {
      Response response = await dio.delete('/user');
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        await ChangedToken().removeToken(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Предупреждение"),
            actions: const [CloseIconButton(iconColor: null, padding: true)]),
        body: const Center(
            child: Text("Вы точно хотите удалить аккаунт?",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                textAlign: TextAlign.center)),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                  child: Button(
                      onPressed: deleteAccount,
                      backgroundColor: ColorComponent.red['100'],
                      titleColor: ColorComponent.red['600'],
                      title: "Удалить")),
              const Divider(indent: 8),
              Expanded(
                  child: Button(
                      onPressed: () => Navigator.pop(context), title: "Отмена"))
            ],
          ),
        )),
      ),
    );
  }
}

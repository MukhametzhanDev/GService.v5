import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

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
    CreateData.data['name'] = nameEditingController.text;
    CreateData.data['phone'] = getIntComponent(phoneEditingController.text).toString();
    CreateData.data['can_lease'] = false;
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          AutofillGroup(
              child: TextField(
                  autofillHints: const [AutofillHints.name],
                  controller: nameEditingController,
                  keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(hintText: "Имя"))),
          Divider(),
          AutofillGroup(
            child: TextField(
                controller: phoneEditingController,
                autofillHints: const [AutofillHints.telephoneNumber],
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(hintText: "Номер телефона")),
          )
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}

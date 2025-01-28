import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/edit/characteristic/editCharacteristicMyAdPage.dart';
import 'package:gservice5/pages/ad/my/edit/contacts/editContactMyAdPage.dart';
import 'package:gservice5/pages/ad/my/edit/images/editImageMyAdPage.dart';

class EditMyAdModal extends StatefulWidget {
  final Map data;
  const EditMyAdModal({super.key, required this.data});

  @override
  State<EditMyAdModal> createState() => _EditMyAdModalState();
}

class _EditMyAdModalState extends State<EditMyAdModal> {
  void showEditImage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditImageMyAdPage(data: widget.data)));
  }

  void showEditContact() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditContactMyAdPage(data: widget.data)));
  }

  void showEditData() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditCharacteristicMyAdPage(data: widget.data)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250 + MediaQuery.of(context).padding.bottom,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: const Text("Выберите"),
          actions: const [CloseIconButton(iconColor: null, padding: true)],
        ),
        body: Column(
          children: [
            ListTile(
                onTap: showEditData,
                title: const Text("Редактировать данные"),
                trailing: SvgPicture.asset("assets/icons/right.svg")),
            Divider(height: 1, color: ColorComponent.gray['100']),
            ListTile(
                onTap: showEditImage,
                title: const Text("Редактировать фото"),
                trailing: SvgPicture.asset("assets/icons/right.svg")),
            Divider(height: 1, color: ColorComponent.gray['100']),
            ListTile(
                onTap: showEditContact,
                title: const Text("Редактировать контакты"),
                trailing: SvgPicture.asset("assets/icons/right.svg"))
          ],
        ),
      ),
    );
  }
}

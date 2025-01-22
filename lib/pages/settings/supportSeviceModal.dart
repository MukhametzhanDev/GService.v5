import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class HelpdeskModal extends StatefulWidget {
  const HelpdeskModal({super.key});

  @override
  State<HelpdeskModal> createState() => _HelpdeskModalState();
}

class _HelpdeskModalState extends State<HelpdeskModal> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/support-request",
          data: {"description": textEditingController.text});
      Navigator.pop(context);
      if (response.data['success']) {
      Navigator.pop(context);
        SnackBarComponent()
            .showDoneMessage("Ваша сообщение успешно отправлено", context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyMessage() {
    if (textEditingController.text.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните строки", context);
    } else {
      sendMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackTitleButton(title: "Служба поддержки"),
          leadingWidth: 240),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        child: Column(
          children: [
            TextField(
                style: const TextStyle(fontSize: 14),
                maxLength: 1000,
                controller: textEditingController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 14,
                minLines: 6,
                decoration: InputDecoration(
                    hintText: "Написать",
                    helperStyle: TextStyle(color: ColorComponent.gray['500']))),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyMessage,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Отправить")),
    );
    // ClipRRect(
    //   borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       AppBar(
    //         automaticallyImplyLeading: false,
    //         title: Text("Служба поддержки"),
    //         centerTitle: false,
    //         actions: [CloseIconButton(iconColor: null, padding: true)],
    //       ),
    //       ListTile(
    //           onTap: () {},
    //           title: Text("WhatsApp"),
    //           trailing: SvgPicture.asset("assets/icons/right.svg")),
    //       Divider(height: 1, color: ColorComponent.gray['100']),
    //       ListTile(
    //           onTap: () {},
    //           title: Text("Telegram"),
    //           trailing: SvgPicture.asset("assets/icons/right.svg")),
    //       Divider(height: 1, color: ColorComponent.gray['100']),
    //       ListTile(
    //           onTap: () {},
    //           title: Text("English"),
    //           trailing: SvgPicture.asset("assets/icons/right.svg")),
    //       Divider(height: 1, color: ColorComponent.gray['100']),
    //       SizedBox(height: MediaQuery.of(context).padding.bottom)
    //     ],
    //   ),
    // );
  }
}

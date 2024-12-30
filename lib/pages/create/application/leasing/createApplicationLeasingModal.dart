import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/select/selectVerifyData.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/component/widgets/characteristic/showCharacteristicWidget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shimmer/shimmer.dart';

class CreateApplicationLeasingModal extends StatefulWidget {
  final Map data;
  const CreateApplicationLeasingModal({super.key, required this.data});

  @override
  State<CreateApplicationLeasingModal> createState() =>
      _CreateApplicationLeasingModalState();
}

class _CreateApplicationLeasingModalState
    extends State<CreateApplicationLeasingModal> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  bool loaderUser = true;
  Map city = {};
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Заявка на лизинг"),
        automaticallyImplyLeading: false,
        actions: const [CloseIconButton(iconColor: null, padding: true)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Информация о спецтехнике",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 8),
            ShowCharacteristicWidget(
                title: "Тип", subTitle: widget.data['transport_type']),
            ShowCharacteristicWidget(
                title: "Марка", subTitle: widget.data['transport_brand']),
            ShowCharacteristicWidget(
                title: "Модель", subTitle: widget.data['transport_model']),
            const ShowCharacteristicWidget(
                title: "Состояние", subTitle: {"title": "Новая"}),
            // const Divider(height: 12),
            // GestureDetector(
            //   onTap: () {},
            //   child: Text("Создать новая заявка",
            //       style: TextStyle(
            //           color: ColorComponent.blue['500'],
            //           fontWeight: FontWeight.w500)),
            // ),
            const Divider(height: 24),
            const Text("Контактная информация",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const Divider(height: 16),
            // const Text("Имя",
            //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            // const Divider(height: 8),
            loaderUser
                ? Shimmer.fromColors(
                    baseColor: const Color(0xffe5e7eb),
                    highlightColor: const Color(0xfff4f5f7),
                    period: const Duration(seconds: 1),
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8))),
                        const Divider(height: 16),
                        Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8))),
                        const Divider(height: 16),
                        Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8))),
                      ],
                    ))
                : Column(
                    children: [
                      AutofillGroup(
                          child: TextField(
                              autofillHints: const [AutofillHints.name],
                              controller: nameEditingController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(fontSize: 14),
                              decoration:
                                  const InputDecoration(hintText: "Имя"))),

                      const Divider(height: 16),
                      // const Text("Номер телефона",
                      //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      // const Divider(height: 8),
                      AutofillGroup(
                        child: TextField(
                            controller: phoneEditingController,
                            autofillHints: const [
                              AutofillHints.telephoneNumber
                            ],
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                hintText: "Номер телефона")),
                      ),
                      const Divider(height: 16),
                      // const Text("Город",
                      //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      // const Divider(height: 8),
                      SelectVerifyData(
                          title: "Город",
                          value: city,
                          onChanged: (value) {
                            city = value;
                            setState(() {});
                          },
                          pagination: false,
                          api: "/cities?country_id=191",
                          showErrorMessage: ""),
                      const Divider(height: 16),
                      // Text(
                      //     "",
                      //     style:
                      //         TextStyle(color: ColorComponent.gray['500'], height: 1.5))
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Column(
        children: [
          Button(
              onPressed: () {
                Navigator.pop(context);
                SnackBarComponent().showDoneMessage(
                    "В ближайшее время с вами свяжутся официальные дилеры и магазины по вопросам лизинга",
                    context);
              },
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Подать заявку"),
        ],
      )),
    );
  }
}

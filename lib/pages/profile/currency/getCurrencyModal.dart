import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/profile/currency/currencyMainPage.dart';

class GetCurrencyModal extends StatefulWidget {
  final List data;
  final Map currentData;
  const GetCurrencyModal(
      {super.key, required this.data, required this.currentData});

  @override
  State<GetCurrencyModal> createState() => _GetCurrencyModalState();
}

class _GetCurrencyModalState extends State<GetCurrencyModal> {
  Map current = {};
  List data = [];

  @override
  void initState() {
    current = widget.currentData;
    data = widget.data;
    super.initState();
  }

  void showEditCurrencyPage() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CurrencyMainPage()))
        .then((value) {
      data = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(
      builder: (context, scrollPhysics) {
        return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Конвертор валют"),
              actions: const [CloseIconButton(iconColor: null, padding: true)]),
          body: SingleChildScrollView(
              child: Column(
            children: [
              const ExplanatoryMessage(
                  title:
                      "Конвертер валют создан для удобного расчета цен при покупках за границей. Курсы произвольные и не являются официальными. Все цены в объявлениях отображаются в тенге.",
                  padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  type: "get_currency"),
              Column(
                  children: data.map((value) {
                bool active = current['id'] == value['id'];
                return Column(children: [
                  Divider(height: 1, color: ColorComponent.gray['100']),
                  ListTile(
                      onTap: () {
                        current = value;
                        setState(() {});
                      },
                      leading: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: active ? Colors.white : const Color(0xffF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: active ? 4 : 1,
                                color: active
                                    ? const Color(0xff3f83f8)
                                    : const Color(0xffD1D5DB))),
                      ),
                      title: RichText(
                          text: TextSpan(
                              style:
                                  const TextStyle(fontSize: 16, color: Colors.black),
                              children: [
                            TextSpan(
                                text: "1 ${value['currency']['symbol']}  "),
                            TextSpan(
                                text: value['currency']['title'],
                                style: TextStyle(
                                    color: ColorComponent.gray['500'])),
                          ])),
                      trailing: Text("${value['in_tenge']} ₸",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500))),
                ]);
              }).toList()),
              Divider(height: 1, color: ColorComponent.gray['100']),
            ],
          )),
          bottomNavigationBar: BottomNavigationBarComponent(
              child: Column(
            children: [
              Button(
                  onPressed: showEditCurrencyPage,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  title: "Изменить валюту"),
              const Divider(),
              Button(
                  onPressed: () {
                    Navigator.pop(context, current);
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  title: "Сохранить"),
            ],
          )),
        );
      },
    );
  }
}

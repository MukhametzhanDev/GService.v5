import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class TransportSaleCurrencyPage extends StatefulWidget {
  const TransportSaleCurrencyPage({super.key});

  @override
  _TransportSaleCurrencyPageState createState() =>
      _TransportSaleCurrencyPageState();
}

class _TransportSaleCurrencyPageState extends State<TransportSaleCurrencyPage> {
  bool loader = true;
  List data = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio
          .get("/company-currency", queryParameters: {"category_id": 1});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        print(data);
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Future postData() async {
    showModalLoader(context);
    try {
      List<Map<String, dynamic>> currencyData = data.map((item) {
        return {
          "currency_id": item['currency']['id'],
          "value": item['in_tenge']
        };
      }).toList();
      print(currencyData);
      Response response = await dio.post("/company-currency",
          data: {"company_currency": currencyData, "category_id": "1"});
      print(response.data);
      if (response.statusCode == 200 && response.data['success']) {
        Navigator.pop(context);
        Navigator.pop(context, response.data['data']);
        SnackBarComponent().showDoneMessage("Валюта успешно изменена", context);
      } else {
        Navigator.pop(context);
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        body: loader
            ? const LoaderComponent()
            : Column(
                children: [
                  const ExplanatoryMessage(
                      title:
                          "Конвертер валют создан для удобного расчета цен при покупках за границей. Курсы произвольные и не являются официальными. Все цены в объявлениях отображаются в тенге.",
                      padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                      type: "my_currency"),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map value = data[index];
                          return Column(children: [
                            Row(children: [
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: ColorComponent.gray['50'],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xffe5e7eb))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "1 ${data[index]['currency']['title']}",
                                              style: TextStyle(
                                                  color: ColorComponent
                                                      .gray['500'])),
                                          Text(
                                              data[index]['currency']['symbol'],
                                              style: TextStyle(
                                                  color: ColorComponent
                                                      .gray['500'])),
                                        ],
                                      ))),
                              const SizedBox(width: 8),
                              const Text("=", style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      initialValue:
                                          data[index]['in_tenge'].toString(),
                                      onChanged: (title) {
                                        value['in_tenge'] = title;
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintStyle: TextStyle(
                                            color: ColorComponent.gray['500'],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                        suffixIcon: Text('₸',
                                            style: TextStyle(
                                                color: ColorComponent
                                                    .gray['500'])),
                                        suffixIconConstraints:
                                            const BoxConstraints(
                                                minWidth: 25, maxWidth: 25),
                                      )))
                            ]),
                            const Divider(height: 12)
                          ]);
                        }),
                  ),
                ],
              ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: postData,
                backgroundColor: ColorComponent.mainColor,
                titleColor: Colors.black,
                icon: null,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                widthIcon: null,
                title: "Сохранить")),
      ),
    );
  }
}

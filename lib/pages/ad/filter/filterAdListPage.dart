import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeTitleButton.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/priceTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/filter/additionallFilterWidget.dart';
import 'package:gservice5/pages/ad/filter/filterResultButton.dart';
import 'package:gservice5/pages/ad/filter/filterSelectModal.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterAdListPage extends StatefulWidget {
  final List data;
  final int categoryId;
  const FilterAdListPage(
      {super.key, required this.data, required this.categoryId});

  @override
  State<FilterAdListPage> createState() => _FilterAdListPageState();
}

class _FilterAdListPageState extends State<FilterAdListPage> {
  Timer? _debounceTimer;
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(
          NumberFormat.currency(decimalDigits: 0, symbol: "", locale: 'kk'));

  Map getParam(Map value) {
    int index = widget.data.indexOf(value);
    if (index <= 0 || index == widget.data.length - 1) {
      return {};
    } else {
      String key = widget.data[index - 1]?['name'] ?? "";
      Map param = {key: FilterData.data[key] ?? ""};
      return param;
    }
  }

  TextEditingController getPrice(String key) {
    Map data = AdFilterProvider().value;
    if (data.containsKey(key)) {
      return TextEditingController(text: "${data[key]}");
    } else {
      return TextEditingController();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void onAddPrice(value, String key) {
    int price = getIntComponent(value);
    var filter = Provider.of<AdFilterProvider>(context, listen: false);
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      if (value!.isEmpty) {
        filter.removeData = key;
      } else {
        filter.filterData = {key: price};
      }
    });
  }

  String getValuePrice(String key) {
    var filter = Provider.of<AdFilterProvider>(context, listen: false);
    String price = (filter.value[key] ?? "").toString();
    if (price.isEmpty) return "";
    String value = currencyTextInputFormatter.formatString(price);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    var filter = Provider.of<AdFilterProvider>(context, listen: false);
    return Consumer<AdFilterProvider>(builder: (context, data, child) {
      print("213412342");
      return Scaffold(
        appBar: AppBar(
          leading: const CloseTitleButton(title: "Фильтр"),
          leadingWidth: 200,
          actions: [
            GestureDetector(
                onTap: () {
                  filter.clearData();
                  Navigator.pop(context, "update");
                },
                child: Text("Сбросить",
                    style: TextStyle(
                        color: ColorComponent.blue['500'],
                        fontWeight: FontWeight.w500))),
            const Divider(indent: 15)
          ],
        ),
        body: GestureDetector(
          onTap: () => closeKeyboard(),
          child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: 10,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: widget.data.map((value) {
                      return FilterSelectModal(
                          title: value['title']['title_ru'],
                          option: value,
                          api: value['url'],
                          param: getParam,
                          value: filter.value["${value['name']}_value"] ?? {});
                    }).toList(),
                  ),
                  FilterSelectModal(
                      title: "Город",
                      option: const {"name": "city_id"},
                      api: "/cities",
                      param: getParam,
                      value: data.value["city_id_value"] ?? {}),
                  const Text("Цена"),
                  const Divider(height: 6),
                  Row(children: [
                    Expanded(
                        child:
                            // PriceTextField(
                            //     textEditingController: TextEditingController(
                            //         text: (filter.value['price_from'] ?? "")
                            //             .toString()),
                            //     autofocus: false,
                            //     onChanged: (value) {
                            //       onAddPrice(value, "price_from");
                            //     },
                            //     title: "От",
                            //     onSubmitted: (value) {})

                            SizedBox(
                      height: 48,
                      child: TextFormField(
                        onChanged: (value) => onAddPrice(value, "price_from"),
                        inputFormatters: [currencyTextInputFormatter],
                        initialValue: getValuePrice("price_from"),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 14, height: 1.1),
                        decoration: InputDecoration(hintText: 'Введите цену'),
                      ),
                    )),
                    const Divider(indent: 12),
                    Expanded(
                        child: SizedBox(
                      height: 48,
                      child: TextFormField(
                        onChanged: (value) => onAddPrice(value, "price_to"),
                        inputFormatters: [currencyTextInputFormatter],
                        initialValue: getValuePrice("price_to"),
                        style: const TextStyle(fontSize: 14, height: 1.1),
                        decoration: InputDecoration(hintText: 'Введите цену'),
                      ),
                    ))
                  ]),
                  AdditionallFilterWidget(
                      categoryId: widget.categoryId, data: data.data)
                ],
              )),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: FilterResultButton(categoryId: widget.categoryId)),
      );
    });
  }
}




// Scaffold(
//         appBar: AppBar(
//           leading: CloseTitleButton(title: "Фильтр"),
//           leadingWidth: 200,
//           actions: [
//             GestureDetector(
//                 onTap: () {
//                   FilterData.data.clear();
//                   Navigator.pop(context, "update");
//                 },
//                 child: Text("Сбросить",
//                     style: TextStyle(
//                         color: ColorComponent.blue['500'],
//                         fontWeight: FontWeight.w500))),
//             Divider(indent: 15)
//           ],
//         ),
//         body
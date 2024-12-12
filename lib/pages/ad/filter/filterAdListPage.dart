import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/back/closeTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/priceTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/filter/filterSelectModal.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class FilterAdListPage extends StatefulWidget {
  final List data;
  const FilterAdListPage({super.key, required this.data});

  @override
  State<FilterAdListPage> createState() => _FilterAdListPageState();
}

class _FilterAdListPageState extends State<FilterAdListPage> {
  Map getParam(Map value) {
    print(value);
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
    Map data = FilterData.data;
    if (data.containsKey(key)) {
      return TextEditingController(text: "${data[key]}");
    } else {
      return TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseTitleButton(title: "Фильтр"),
        leadingWidth: 200,
        actions: [
          GestureDetector(
              onTap: () {
                FilterData.data.clear();
                Navigator.pop(context, "update");
              },
              child: Text("Сбросить",
                  style: TextStyle(
                      color: ColorComponent.blue['500'],
                      fontWeight: FontWeight.w500))),
          Divider(indent: 15)
        ],
      ),
      body: GestureDetector(
        onTap: () => closeKeyboard(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: 10,
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(context).viewInsets.bottom +
                        MediaQuery.of(context).padding.bottom),
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
                            value: FilterData.data["${value['name']}_value"] ??
                                {});
                      }).toList(),
                    ),
                    FilterSelectModal(
                        title: "Город",
                        option: {"name": "city_id"},
                        api: "/cities",
                        param: getParam,
                        value: FilterData.data["city_id_value"] ?? {}),
                    Text("Цена"),
                    Divider(height: 6),
                    Row(children: [
                      Expanded(
                          child: PriceTextField(
                              textEditingController: getPrice("price_from"),
                              autofocus: false,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  FilterData.data.remove("price_from");
                                } else {
                                  FilterData.data['price_from'] =
                                      getIntComponent(value);
                                }
                              },
                              title: "От",
                              onSubmitted: () {})),
                      Divider(indent: 12),
                      Expanded(
                          child: PriceTextField(
                              textEditingController: getPrice("price_to"),
                              autofocus: false,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  FilterData.data.remove("price_to");
                                } else {
                                  FilterData.data['price_to'] =
                                      getIntComponent(value);
                                }
                              },
                              title: "До",
                              onSubmitted: () {}))
                    ]),
                  ],
                )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
        onPressed: () {
          Navigator.pop(context, "update");
        },
        title: "Поиск",
        padding: EdgeInsets.symmetric(horizontal: 15),
      )),
    );
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
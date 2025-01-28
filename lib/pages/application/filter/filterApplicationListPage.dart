import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/textField/priceTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';
import 'package:gservice5/pages/ad/filter/filterSelectModal.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class FilterApplicationListPage extends StatefulWidget {
  const FilterApplicationListPage({super.key});

  @override
  State<FilterApplicationListPage> createState() =>
      _FilterApplicationListPageState();
}

class _FilterApplicationListPageState extends State<FilterApplicationListPage> {
  @override
  void initState() {
    print(FilterData.data);
    super.initState();
  }

  Map getParam(Map value) {
    return {};
  }

  TextEditingController getPrice(String key) {
    Map data = FilterData.data;
    if (data.containsKey(key)) {
      return TextEditingController(text: "${data[key]}");
    } else {
      return TextEditingController();
    }
  }

  Map categoryValue() {
    bool hasCategory = FilterData.data.containsKey("category_id_value");
    if (hasCategory) {
      return FilterData.data['category_id_value'];
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseTitleButton(title: "Фильтр"),
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
          const Divider(indent: 15)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterSelectModal(
                title: "Разделы",
                api: "/application-categories",
                option: const {"name": "category_id"},
                value: categoryValue(),
                param: (value) => {}),
            FilterSelectModal(
                title: context.localizations.city,
                option: const {"name": "city_id"},
                api: "/cities",
                param: getParam,
                value: FilterData.data["city_id_value"] ?? {}),
             Text(context.localizations.price),
            const Divider(height: 6),
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
                      onSubmitted: (value) {})),
              const Divider(indent: 12),
              Expanded(
                  child: PriceTextField(
                      textEditingController: getPrice("price_to"),
                      autofocus: false,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          FilterData.data.remove("price_to");
                        } else {
                          FilterData.data['price_to'] = getIntComponent(value);
                        }
                      },
                      title: "До",
                      onSubmitted: (value) {}))
            ]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {
                Navigator.pop(context, "update");
              },
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Поиск")),
    );
  }
}

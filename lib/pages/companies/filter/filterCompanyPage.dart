import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/filter/filterSelectModal.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:provider/provider.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class FilterCompanyPage extends StatefulWidget {
  const FilterCompanyPage({super.key});

  @override
  State<FilterCompanyPage> createState() => _FilterCompanyPageState();
}

class _FilterCompanyPageState extends State<FilterCompanyPage> {
  // Map getParam(Map value) {
  //   print(FilterData.data);
  //   int index = widget.data.indexOf(value);
  //   if (index <= 0 || index == widget.data.length - 1) {
  //     return {};
  //   } else {
  //     String key = widget.data[index - 1]?['name'] ?? "";
  //     Map param = {key: FilterData.data[key] ?? ""};
  //     return param;
  //   }
  // }

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
    final filterData = Provider.of<AdFilterProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseTitleButton(title: "Фильтр"),
        leadingWidth: 200,
        actions: [
          GestureDetector(
              onTap: () {
                filterData.clearData();
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
            child: Consumer<AdFilterProvider>(builder: (context, data, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterSelectModal(
                      title: context.localizations.city,
                      option: const {"name": "city_id"},
                      api: "/cities",
                      param: (value) {
                        return {};
                      },
                      value: data.data["city_id_value"] ?? {}),
                  FilterSelectModal(
                      title: "Категория и вид деятельности",
                      option: const {"name": "category_id"},
                      api: "/categories",
                      param: (value) {
                        return {};
                      },
                      value: data.data["category_id_value"] ?? {}),
                  FilterSelectModal(
                      title: "Тип техники",
                      option: const {"name": "transport_brand_id"},
                      api: "/transport-brands",
                      param: (value) {
                        return {};
                      },
                      value: data.data["transport_brand_id_value"] ?? {}),
                ],
              );
            })),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
        onPressed: () {
          Navigator.pop(context, "update");
        },
        title: "Поиск",
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
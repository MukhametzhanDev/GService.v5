import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/select/multi/multiSelect.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class FilterActivityCompanyModal extends StatefulWidget {
  const FilterActivityCompanyModal({super.key});

  @override
  State<FilterActivityCompanyModal> createState() =>
      _FilterActivityCompanyModalState();
}

class _FilterActivityCompanyModalState
    extends State<FilterActivityCompanyModal> {
  List categories = [];
  List transportTypes = [];
  List transportBrands = [];

  void postData() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/company-activity", data: {
        "category_id": getIds(categories),
        "transport_type_id": getIds(transportTypes),
        "transport_brand_id": getIds(transportBrands)
      });
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        context.router.pushAndPopUntil(const BusinessBottomRoute(),
            predicate: (route) => false);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    if (categories.isEmpty) {
      SnackBarComponent()
          .showErrorMessage("Заполните поля 'Вид деятельности'", context);
    } else {
      postData();
    }
  }

  List<int> getIds(List data) {
    List<int> ids = [];
    for (Map value in data) {
      ids.add(value['id']);
    }
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const CloseTitleButton(title: "Описание деятельности"),
          leadingWidth: 300),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(children: [
          MultiSelect(
            title: "Вид деятельности",
            api: "/categories",
            pagination: false,
            value: categories,
            onChanged: (value) {
              categories = value;
              setState(() {});
            },
          ),
          // MultiSelect(
          //   title: "Тип техники",
          //   api: "/transport-types",
          //   pagination: true,
          //   value: transportTypes,
          //   onChanged: (value) {
          //     transportTypes = value;
          //     setState(() {});
          //   },
          // ),
          MultiSelect(
            title: "Официальное диллерство",
            api: "/transport-brands",
            value: transportBrands,
            pagination: true,
            onChanged: (value) {
              transportBrands = value;
              setState(() {});
            },
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: context.localizations.save)),
    );
  }
}

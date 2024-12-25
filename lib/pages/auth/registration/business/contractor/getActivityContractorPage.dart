import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/select/multi/multiSelect.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/navigation/contractor/contractorBottomTab.dart';

class GetActivityContractorPage extends StatefulWidget {
  const GetActivityContractorPage({super.key});

  @override
  State<GetActivityContractorPage> createState() =>
      _GetActivityContractorPageState();
}

class _GetActivityContractorPageState extends State<GetActivityContractorPage> {
  List categories = [];
  List transportTypes = [];
  List transportBrands = [];

  void postData() async {
    showModalLoader(context);
    String? token = await ChangedToken().getToken();
    print(token);
    try {
      Response response = await dio.post("/company-activity",
          data: {
            "category_id": getIds(categories),
            "transport_type_id": getIds(transportTypes),
            "transport_brand_id": getIds(transportBrands)
          },
          options: Options(headers: {"authorization": "Bearer $token"}));
      print(response.data);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ContractorBottomTab()),
            (route) => false);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    }on DioException catch (e) {
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
      appBar: AppBar(title: const Text("Описание деятельности")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(children: [
          const ExplanatoryMessage(
              title:
                  "По выбранному типу деятельности, вам будут поступать заказы от клиентов",
              padding: EdgeInsets.only(bottom: 15),
              type: "activity"),
          // Divider(),
          MultiSelect(
            title: "Вид деятельности",
            api: "/categories",
            pagination: false,
            onChanged: (value) {
              categories = value;
              setState(() {});
            },
          ),
          MultiSelect(
            title: "Тип техники",
            api: "/transport-types",
            pagination: true,
            onChanged: (value) {
              transportTypes = value;
              setState(() {});
            },
          ),
          MultiSelect(
            title: "Официальное диллерство",
            api: "/transport-brands",
            pagination: true,
            onChanged: (value) {
              transportBrands = value;
              setState(() {});
            },
          ),
          Text("Вы сможете позже отредактировать описание деятельности",
              style: TextStyle(color: ColorComponent.gray['500']))
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Сохранить")),
    );
  }
}

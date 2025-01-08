import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:gservice5/pages/testCharactestic/characteristicWidgets.dart';

class TestCharactesticPage extends StatefulWidget {
  final void Function(List data) nextPage;
  final void Function() previousPage;
  final Map<String, dynamic> param;
  const TestCharactesticPage(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.param});

  @override
  State<TestCharactesticPage> createState() => _TestCharactesticPageState();
}

class _TestCharactesticPageState extends State<TestCharactesticPage> {
  List data = [];
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response =
          await dio.get("/characteristics", queryParameters: widget.param);
      print(response.data);
      if (response.data['success']) {
        data = response.data['data'];
        setState(() {});

        // for (int i = 0; i < data.length; i++) {
        //   final idList = data[i]?['id']?.toString();
        //   final listName = data[i]?['title'];
        //   final fieldType = data[i]?['field_type'];
        //   List options = data[i]?['options'];

        //   print('fieldType ${fieldType}');

        //   if (data[i]['field_type'] == 'select') {
        //     print('+++ select');
        //     await GetIt.I<FirebaseAnalytics>().logViewItemList(
        //         parameters: {'step': 'Характеристика', 'field_type': fieldType},
        //         itemListId:
        //             '${GAParams.adCharacteristicChildListId}_${idList.toString()}',
        //         itemListName: listName,
        //         items: options
        //             .map((toElement) => AnalyticsEventItem(
        //                 itemName: toElement?['title'],
        //                 itemId: toElement?['id'].toString()))
        //             .toList());
        //   }
        // }
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void verifyData() async {
    for (Map value in data) {
      print(value);
      bool hasKey =
          CreateData.characteristic.containsKey(value['id'].toString());
      if (hasKey) {
        String title =
            CreateData.characteristic["${value['id']}"].toString().trim();
        if (value['is_required'] && title.isEmpty) {
          SnackBarComponent().showErrorMessage(
              "Заполните строку '${value['title']}'", context);
          return;
        }
      } else {
        SnackBarComponent()
            .showErrorMessage("Заполните строку '${value['title']}'", context);
        return;
      }
    }
    print(CreateData.characteristic);

    showPage();
  }

  Future getStructureTransportType(String? filterKey) async {
    showModalLoader(context);
    try {
      Response response = await dio.get("/characteristics",
          queryParameters: {filterKey!: CreateData.data[filterKey]});
      print("---->${response.data}");
      Navigator.pop(context);
      if (response.data['success']) {
        List resp = response.data['data'] ?? [];
        widget.nextPage(resp);
        pageControllerIndexedStack.nextPage();
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void showPage() {
    Map characteristics = CreateData.characteristic['characteristics'];
    bool isAvailable = characteristics['is_available'];
    if (isAvailable) {
      String? filterKey = characteristics['filter_key'];
      getStructureTransportType(filterKey);
    } else {
      widget.nextPage([]);
      pageControllerIndexedStack.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        body: data.isEmpty
            ? const LoaderComponent()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: CharacteristicWidget(data: data)),
        bottomNavigationBar: data.isEmpty
            ? const SizedBox.shrink()
            : BottomNavigationBarComponent(
                child: Button(
                    onPressed: () {
                      print(CreateData.characteristic);
                      verifyData();
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    title: "Продолжить")),
      ),
    );
  }
}

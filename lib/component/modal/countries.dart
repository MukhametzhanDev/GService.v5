import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Countries extends StatefulWidget {
  final void Function(Map value) onPressed;
  final Map data;
  final String? fromPage;
  const Countries(
      {super.key, required this.onPressed, required this.data, this.fromPage});

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  List data = [];
  List filterData = [];
  bool loader = true;

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    getData();
    // scrollController.addListener(() => _scrollListener());
  }

  Future getData() async {
    try {
      Response response = await dio.get("/countries");
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        filterData = response.data['data'];
        loader = false;
        setState(() {});

        await analytics.logViewItemList(
            itemListId: GAParams.listCountriesId,
            itemListName: GAParams.listCountriesName,
            parameters: {GAKey.screenName: widget.fromPage ?? ''},
            items: data
                .map((toElement) => AnalyticsEventItem(
                    itemName: toElement['title'],
                    itemId: toElement['id'].toString()))
                .toList());
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void addTitle(String value) {
    if (value.isNotEmpty) {
      filterData = data
          .where((element) =>
              element['title'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      filterData = data;
    }
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void savedData(Map value) {
    Navigator.pop(context);
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Cities(
            onPressed: (city) {
              getCity(value, city);
            },
            countryId: value['id']));

    analytics.logSelectItem(
        itemListId: GAParams.listCountriesId,
        itemListName: GAParams.listCountriesName,
        items: [
          AnalyticsEventItem(
              itemId: value['id']?.toString(), itemName: value['title'])
        ]).catchError((e) {
      if (kDebugMode) {
        debugPrint(e);
      }
    });
  }

  void getCity(country, city) {
    Map param = {"country": country, "city": city};
    widget.onPressed(param);
  }

  int getIdCurrent() {
    if (widget.data.isNotEmpty) {
      return widget.data['country']['id'];
    } else {
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: Container(),
          leadingWidth: 0,
          title: const Text("Выберите страны",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          actions: const [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 60),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child:
                    SearchTextField(title: "Поиск страны", onChanged: addTitle),
              )),
        ),
        body: loader
            ? const LoaderComponent()
            : ListView.builder(
                physics: physics,
                controller: scrollController,
                itemCount: filterData.length,
                itemBuilder: (context, index) {
                  Map item = filterData[index];
                  bool currentItem = item['id'] == getIdCurrent();
                  return Container(
                    decoration: BoxDecoration(
                        color: currentItem ? ColorComponent.gray['100'] : null,
                        border: const Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xfff4f5f7)))),
                    child: ListTile(
                      onTap: () {
                        savedData(item);
                      },
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: SvgPicture.network(item['flag'], width: 20)),
                      title: Text(item['title'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      trailing: SizedBox(
                        width: 18,
                        child: SvgPicture.asset(
                            currentItem
                                ? 'assets/icons/check.svg'
                                : 'assets/icons/right.svg',
                            color: currentItem
                                ? ColorComponent.blue['500']
                                : null),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}

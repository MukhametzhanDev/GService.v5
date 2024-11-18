import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';

class GetTypeEquipmentPage2 extends StatefulWidget {
  final bool multiple;
  const GetTypeEquipmentPage2({super.key, required this.multiple});

  @override
  State<GetTypeEquipmentPage2> createState() => _GetTypeEquipmentPage2State();
}

class _GetTypeEquipmentPage2State extends State<GetTypeEquipmentPage2> {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";
  List multipleData = [];
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  @override
  void initState() {
    getData();
    scrollController.addListener(() {
      loadMoreAd();
    });
    super.initState();
  }

  Future getData() async {
    try {
      Response response =
          await dio.get("/transport-types", queryParameters: {"title": title});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        activedData(data);
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 200 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio.get("/transport-types",
            queryParameters: {"page": page.toString(), "title": title});
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          activedData(data);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void activedData(List data) {
    final idsSet = multipleData.toSet();
    data.map((item) {
      if (idsSet.contains(item['id'])) {
        item['active'] = true;
      }
    }).toList();
  }

  void activedItem(Map value) {
    if (widget.multiple) {
      if (value?['active'] ?? false) {
        value['active'] = false;
        multipleData.remove(value['id']);
      } else {
        value['active'] = true;
        multipleData.add(value['id']);
      }
    } else {
      CreateData.data['transport_type_id'] = value['id'];
      pageControllerIndexedStack.nextPage();
    }
    setState(() {});
  }

  void savedData() {
    CreateData.data['transport_type_ids'] = multipleData;
    pageControllerIndexedStack.nextPage();
  }

  void searchList(value) {
    title = value;
    loader = true;
    setState(() {});
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
            child: SearchTextField(title: "Поиск", onChanged: searchList)),
        Expanded(
          child: loader
              ? LoaderComponent()
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  itemCount: data.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    Map value = data[index];
                    if (data.length - 1 == index) {
                      return Column(children: [
                        Item(value),
                        isLoadMore ? LoaderPaginationComponent() : Container()
                      ]);
                    } else {
                      return Item(value);
                    }
                  }),
        )
      ]),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () => savedData(),
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }

  Widget Item(Map value) {
    bool active = value['active'] ?? false;
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffF5f5f5)))),
      child: ListTile(
        onTap: () => activedItem(value),
        title: Text(value['title']),
        trailing: widget.multiple
            ? CheckItem(active)
            : SvgPicture.asset('assets/icons/right.svg'),
      ),
    );
  }

  Widget CheckItem(bool active) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: active ? ColorComponent.blue['500'] : Colors.white,
          border: Border.all(
              width: 1, color: active ? Color(0xff3f83f8) : Color(0xff9fa6b2)),
          borderRadius: BorderRadius.circular(4)),
      child: active
          ? SvgPicture.asset('assets/icons/check.svg', color: Colors.white)
          : Container(),
    );
  }
}

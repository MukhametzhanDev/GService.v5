import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';

class Cities extends StatefulWidget {
  final void Function(Map value) onPressed;
  final int countryId;
  const Cities({super.key, required this.onPressed, required this.countryId});

  @override
  State<Cities> createState() => _CitiesState();
}

class _CitiesState extends State<Cities> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  List data = [];
  List filterData = [];
  bool loader = true;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";

  @override
  void initState() {
    super.initState();
    getData();
    scrollController.addListener(() => loadMoreAd());
  }

  Future getData() async {
    try {
      page = 1;
      Response response = await dio.get("/cities", queryParameters: {
        "country_id": widget.countryId,
        "title": title,
        "page": page
      });
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        filterData = response.data['data'];
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
        Response response = await dio.get("/cities", queryParameters: {
          "country_id": widget.countryId,
          "title": title,
          "page": page
        });
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          filterData.addAll(response.data['data']);
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void savedData(Map value) {
    widget.onPressed(value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: Container(),
          leadingWidth: 0,
          title: const Text("Выберите город",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          actions: const [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 60),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child: SearchTextField(
                    title: "Поиск город",
                    onChanged: (value) {
                      title = value;
                      setState(() {});
                      getData();
                    }),
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
                  if (index == filterData.length - 1) {
                    return Column(children: [
                      Item(item),
                      isLoadMore
                          ? const LoaderPaginationComponent()
                          : Container()
                    ]);
                  } else {
                    return Item(item);
                  }
                },
              ),
      );
    });
  }

  Widget Item(Map item) {
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
      child: ListTile(
          onTap: () {
            savedData(item);
          },
          title: Text(item['title'],
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
    );
  }
}

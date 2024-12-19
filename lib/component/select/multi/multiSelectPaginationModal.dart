import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class MultiSelectPaginationModal extends StatefulWidget {
  final String title;
  final String api;
  final void Function(List data) onChanged;
  final List data;
  const MultiSelectPaginationModal(
      {super.key,
      required this.title,
      required this.api,
      required this.onChanged,
      required this.data});

  @override
  State<MultiSelectPaginationModal> createState() =>
      _MultiSelectPaginationModalState();
}

class _MultiSelectPaginationModalState
    extends State<MultiSelectPaginationModal> {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";

  @override
  void initState() {
    getData();
    scrollController.addListener(() {
      loadMoreAd();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future getData() async {
    try {
      Response response =
          await dio.get(widget.api, queryParameters: {"title": title});
      print(response.data);
             if (response.statusCode==200) {

        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        activedData(response.data['data']);
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
        Response response = await dio.get(widget.api,
            queryParameters: {"page": page.toString(), "title": title});
        print(response.data);
               if (response.statusCode==200) {

          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          activedData(response.data['data']);
          setState(() {});
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void activedData(data) {
    for (Map value in data) {
      for (Map element in widget.data) {
        if (value['id'] == element['id']) {
          value['active'] = true;
        }
      }
    }
  }

  void activedItem(Map value) {
    if (value['active'] ?? false) {
      value['active'] = false;
    } else {
      value['active'] = true;
    }
    setState(() {});
  }

  void savedData() {
    List values = data.where((value) => value['active'] ?? false).toList();
    print(values);
    widget.onChanged(values);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
          actions: const [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 50),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  child: SearchTextField(
                      title: "Поиск",
                      onChanged: (value) {
                        title = value;
                        setState(() {});
                        getData();
                      }))),
        ),
        body: loader
            ? const LoaderComponent()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 15),
                physics: physics,
                itemCount: data.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  Map value = data[index];
                  if (data.length - 1 == index) {
                    return Column(children: [
                      Item(value),
                      isLoadMore ? const LoaderPaginationComponent() : Container()
                    ]);
                  } else {
                    return Item(value);
                  }
                }),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: savedData,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                title: "Сохранить")),
      );
    });
  }

  Widget Item(Map value) {
    bool active = value['active'] ?? false;
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
      child: ListTile(
        onTap: () => activedItem(value),
        leading: Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: active ? const Color(0xff1A56DB) : null,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  width: 1,
                  color: active ? const Color(0xff1A56DB) : const Color(0xffD1D5DB))),
          child: active
              ? SvgPicture.asset('assets/icons/checkMini.svg',
                  color: Colors.white)
              : Container(),
        ),
        title: Text(value['title']),
      ),
    );
  }
}

import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditSelectModal extends StatefulWidget {
  final String title;
  final String api;
  final Map option;
  final Map value;
  const EditSelectModal(
      {super.key,
      required this.title,
      required this.api,
      required this.option,
      required this.value});

  @override
  State<EditSelectModal> createState() => _EditSelectModalState();
}

class _EditSelectModalState extends State<EditSelectModal> {
  Map currentData = {};

  @override
  void initState() {
    currentData = widget.value;
    EditData.data.addAll({widget.option['name']: widget.value['id']});
    super.initState();
  }

  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => SelectModal(
            title: widget.title,
            api: widget.api,
            data: widget.value)).then((value) {
      currentData = value;
      EditData.data.addAll({widget.option['name']: widget.value['id']});
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showModal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Divider(height: 6),
          Container(
            height: 48,
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
                color: Color(0xffF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Color(0xffE5E5EA))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(currentData?['title'] ?? "Выберите",
                      style: TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis)),
                ),
                SvgPicture.asset('assets/icons/down.svg')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectModal extends StatefulWidget {
  final String title;
  final String api;
  final Map data;
  const SelectModal(
      {super.key, required this.title, required this.api, required this.data});

  @override
  State<SelectModal> createState() => _SelectModalState();
}

class _SelectModalState extends State<SelectModal> {
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
      page = 1;
      setState(() {});
      Response response = await dio
          .get(widget.api, queryParameters: {"title": title, "page": page});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
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
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio.get(widget.api,
            queryParameters: {"page": page.toString(), "title": title});
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
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

  void activedItem(Map value) {
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
          actions: [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 50),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  child: SearchTextField(
                      title: "Поиск",
                      onChanged: (value) {
                        title = value;
                        getData();
                      }))),
        ),
        body: loader
            ? LoaderComponent()
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                physics: physics,
                controller: scrollController,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Map value = data[index];
                  bool active = value['id'] == widget.data['id'];
                  if (data.length - 1 == index) {
                    return Column(children: [
                      ListItem(value, active),
                      hasNextPage ? PaginationLoaderComponent() : Container()
                    ]);
                  } else {
                    return ListItem(value, active);
                  }
                }),
      );
    });
  }

  Widget ListItem(Map value, bool active) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
      child: ListTile(
        onTap: () => activedItem(value),
        title: Text(value['title']),
        trailing: active
            ? SvgPicture.asset(
                'assets/icons/checkMini.svg',
                color: ColorComponent.blue['500'],
                width: 20,
              )
            : SvgPicture.asset('assets/icons/right.svg'),
      ),
    );
  }
}

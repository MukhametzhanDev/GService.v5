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
import 'package:gservice5/component/theme/colorComponent.dart';

class SelectModal extends StatefulWidget {
  final String title;
  final String api;
  final void Function(Map data) onChanged;
  final Map data;
  const SelectModal(
      {super.key,
      required this.title,
      required this.api,
      required this.onChanged,
      required this.data});

  @override
  State<SelectModal> createState() => _SelectModalState();
}

class _SelectModalState extends State<SelectModal> {
  bool loader = true;
  List data = [];
  List filterData = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get(widget.api);
      print(response.data);
      if (response.statusCode == 200) {
        filterData = response.data['data'];
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void activedItem(Map value) {
    widget.onChanged(value);
    Navigator.pop(context);
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
                  child: SearchTextField(title: "Поиск", onChanged: addTitle))),
        ),
        body: loader
            ? LoaderComponent()
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                physics: physics,
                itemCount: filterData.length,
                itemBuilder: (context, index) {
                  Map value = filterData[index];
                  bool active = value['id'] == widget.data['id'];
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1, color: Color(0xffeeeeee)))),
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
                }),
      );
    });
  }
}

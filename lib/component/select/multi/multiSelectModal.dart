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

class MultiSelectModal extends StatefulWidget {
  final String title;
  final String api;
  final void Function(List data) onChanged;
  final List data;
  const MultiSelectModal(
      {super.key,
      required this.title,
      required this.api,
      required this.onChanged,
      required this.data});

  @override
  State<MultiSelectModal> createState() => _MultiSelectModalState();
}

class _MultiSelectModalState extends State<MultiSelectModal> {
  List data = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get(widget.api);
      print(response.data);
             if (response.statusCode==200) {

        data = response.data['data'];
        loader = false;
        activedData();
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void activedData() {
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
          actions: [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 50),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  child:
                      SearchTextField(title: "Поиск", onChanged: (value) {}))),
        ),
        body: loader
            ? LoaderComponent()
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                physics: physics,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Map value = data[index];
                  bool active = value['active'] ?? false;
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1, color: Color(0xffeeeeee)))),
                    child: ListTile(
                      onTap: () => activedItem(value),
                      leading: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: active ? Color(0xff1A56DB) : null,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                width: 1,
                                color: active
                                    ? Color(0xff1A56DB)
                                    : Color(0xffD1D5DB))),
                        child: active
                            ? SvgPicture.asset('assets/icons/checkMini.svg',
                                color: Colors.white)
                            : Container(),
                      ),
                      title: Text(value['title']),
                    ),
                  );
                }),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: savedData,
                padding: EdgeInsets.symmetric(horizontal: 16),
                title: "Сохранить")),
      );
    });
  }
}

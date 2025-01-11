import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterButton.dart';
import 'package:gservice5/pages/ad/filter/filterSelectModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FixedAdBusinessFilterAppBar extends StatefulWidget {
  const FixedAdBusinessFilterAppBar({super.key});

  @override
  State<FixedAdBusinessFilterAppBar> createState() =>
      _FixedAdBusinessFilterAppBarState();
}

class _FixedAdBusinessFilterAppBarState
    extends State<FixedAdBusinessFilterAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(children: [
        const FixedStatusAd(),
        const Divider(height: 10),
        Container(
          padding: const EdgeInsets.only(left: 15),
          height: 40,
          child: Row(children: [
            Expanded(
                child: SearchTextField(title: "Поиск", onChanged: (value) {})),
            const Divider(indent: 10),
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorComponent.gray['50'],
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(width: 1, color: ColorComponent.gray['200']!)),
              child: SvgPicture.asset("assets/icons/starLine.svg",
                  color: ColorComponent.gray['500']),
            ),
            const Divider(indent: 10),
            Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorComponent.gray['50'],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1, color: ColorComponent.gray['200']!)),
                child: SvgPicture.asset("assets/icons/upDown.svg",
                    color: ColorComponent.gray['500'])),
            const Divider(indent: 10),
            Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorComponent.gray['50'],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1, color: ColorComponent.gray['200']!)),
                child: SvgPicture.asset("assets/icons/filterOutline2.svg",
                    color: ColorComponent.gray['500'])),
            const Divider(indent: 15),
          ]),
        )
      ]),
    );
  }
}

class FixedStatusAd extends StatefulWidget {
  const FixedStatusAd({super.key});

  @override
  State<FixedStatusAd> createState() => _FixedStatusAdState();
}

class _FixedStatusAdState extends State<FixedStatusAd> {
  final List _tabs = [
    {"active": true, "title": "Активные", "type": "pending", "count": ""},
    {"active": false, "title": "В архвие", "type": "archived", "count": ""},
    {"active": false, "title": "Удаленное", "type": "deleted", "count": ""},
    // {"title": "Отклоненные"},
  ];

  @override
  void initState() {
    getCount();
    super.initState();
  }

  Future getCount() async {
    try {
      Response response = await dio.get("/my-ads-status-count");
      if (response.data['success']) {
        Map data = response.data['data'];
        for (var value in _tabs) {
          value['count'] = data[value['type']].toString();
        }
        setState(() {});
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        child: Row(
            children: _tabs.map((value) {
          return Container(
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: value['active'] ? const Color(0xffF4F4F4) : Colors.white),
              child: Row(
                children: [
                  Text(value['title']),
                  const Divider(indent: 10),
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorComponent.mainColor.withOpacity(.4)),
                    child: Text(
                      12.toString(),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  )
                ],
              ));
        }).toList()),
      ),
    );
  }
}

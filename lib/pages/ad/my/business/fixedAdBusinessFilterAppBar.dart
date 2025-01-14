import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterAdListPage.dart';
import 'package:gservice5/pages/ad/my/business/sortAdsModal.dart';
import 'package:gservice5/pages/ad/my/business/updateAds.dart';

class FixedAdBusinessFilterAppBar extends StatefulWidget {
  const FixedAdBusinessFilterAppBar({super.key});

  @override
  State<FixedAdBusinessFilterAppBar> createState() =>
      _FixedAdBusinessFilterAppBarState();
}

class _FixedAdBusinessFilterAppBarState
    extends State<FixedAdBusinessFilterAppBar> {
  Map<String, dynamic> param = UpdateAds.value;

  @override
  void initState() {
    // checkFilter();
    super.initState();
  }

 

  void activedPackageAds() {
    UpdateAds.addValue = {"package": !param['package']};
    setState(() {});
  }

  void showSortModal() {
    showModalBottomSheet(
        context: context, builder: (context) => const SortAdsModal());
  }

  void showFilterModal() {
    // showModalBottomSheet(
    //     context: context, builder: (context) => FilterAdListPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(left: 15),
          height: 40,
          child: Row(children: [
            Expanded(
                child: SearchTextField(title: "Поиск", onChanged: (value) {})),
            const Divider(indent: 10),
            GestureDetector(
              onTap: activedPackageAds,
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: param['package']
                        ? ColorComponent.mainColor
                        : ColorComponent.gray['50'],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: param['package'] ? 0 : 1,
                        color: ColorComponent.gray['200']!)),
                child: SvgPicture.asset("assets/icons/starLine.svg",
                    color: param['package']
                        ? Colors.black
                        : ColorComponent.gray['500']),
              ),
            ),
            const Divider(indent: 10),
            GestureDetector(
              onTap: showSortModal,
              child: Container(
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
            ),
            const Divider(indent: 10),
            GestureDetector(
              onTap: showFilterModal,
              child: Container(
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
            ),
            const Divider(indent: 15),
          ]),
        )
      ]),
    );
  }
}

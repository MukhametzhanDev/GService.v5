import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterButton.dart';
import 'package:gservice5/pages/companies/filter/filterActivityCompanyModal.dart';
import 'package:gservice5/pages/companies/filter/filterCompanyPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FilterCompanyAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final AppBar appBar;
  final void Function(String value) onChanged;
  const FilterCompanyAppBarWidget(
      {super.key, required this.appBar, required this.onChanged});

  @override
  State<FilterCompanyAppBarWidget> createState() =>
      _FilterCompanyAppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height + 46);
}

class _FilterCompanyAppBarWidgetState extends State<FilterCompanyAppBarWidget> {
  Map city = {};
  Map activity = {};

  @override
  void initState() {
    addData();
    super.initState();
  }

  void addData() {
    bool hasCity = FilterData.data.containsKey("city_id_value");
    if (hasCity) {
      city = FilterData.data['city_id_value'] ?? {};
    } else {
      onClearCity();
    }

    setState(() {});
    widget.onChanged("update");
  }

  void showCityList() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Cities(onPressed: onChangedCity, countryId: 191);
      },
    );
  }

  void showFilterActivity() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterActivityCompanyModal();
      },
    );
  }

  void onChangedCity(Map value) {
    city = value;
    FilterData.data['city_id_value'] = value;
    FilterData.data['city_id'] = value['id'];
    setState(() {});
    widget.onChanged("update");
  }

  void onClearCity() {
    city.clear();
    FilterData.data.remove("city_id");
    FilterData.data.remove("city_id_value");
    setState(() {});
    widget.onChanged("update");
  }

  void showFilterPage() {
    showCupertinoModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (context) => FilterCompanyPage()).then(filteredAds);
  }

  void filteredAds(value) {
    if (value != null) {
      addData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: MediaQuery.of(context).size.width - 100,
      actions: [
        FilterButton(showFilterPage: showFilterPage)
        // GestureDetector(
        //   onTap: () => showFilterPage(),
        //   child: Container(
        //     width: 36,
        //     height: 36,
        //     alignment: Alignment.center,
        //     margin: EdgeInsets.only(right: 15),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(8),
        //         color: ColorComponent.mainColor),
        //     child: SvgPicture.asset("assets/icons/filter.svg", width: 20),
        //   ),
        // )
      ],
      leading: BackTitleButton(
          title: "Компании", onPressed: () => Navigator.pop(context)),
      bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 46),
          child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 2, color: Color(0xfff4f5f7)))),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: showCityList,
                    child: Container(
                        height: 36,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 12),
                        padding: EdgeInsets.only(
                            left: 12, right: city.isNotEmpty ? 6 : 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1,
                                color: city.isNotEmpty
                                    ? ColorComponent.mainColor
                                    : const Color(0xffD1D5DB)),
                            color: ColorComponent.gray['50']),
                        child: Row(
                          children: [
                            Text(
                                city.isNotEmpty
                                    ? FilterData.data['city_id_value']['title']
                                    : "Все города",
                                style: TextStyle(
                                    color: city.isNotEmpty
                                        ? Colors.black
                                        : ColorComponent.gray['500'])),
                            const Divider(indent: 6),
                            city.isNotEmpty
                                ? GestureDetector(
                                    onTap: onClearCity,
                                    child: Container(
                                        width: 24,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            'assets/icons/close.svg',
                                            color: Colors.black)),
                                  )
                                : SvgPicture.asset('assets/icons/down.svg')
                          ],
                        )),
                  ),
                ],
              ))),
    );
  }
}

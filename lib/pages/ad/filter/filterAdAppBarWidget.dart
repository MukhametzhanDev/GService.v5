import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterAdListPage.dart';
import 'package:gservice5/pages/ad/filter/filterButton.dart';
import 'package:gservice5/pages/ad/filter/priceFilterModal.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class FilterAdAppBarWidget extends StatefulWidget
   
    implements PreferredSizeWidget {
  final Map category;
  final AppBar appBar;
  final void Function(String value) onChanged;
  const FilterAdAppBarWidget(
      {super.key,
      required this.category,
      required this.appBar,
      required this.onChanged});

  @override
  State<FilterAdAppBarWidget> createState() => _FilterAdAppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height + 46);
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height + 46);
}

class _FilterAdAppBarWidgetState extends State<FilterAdAppBarWidget> {
  void showCityList() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Cities(onPressed: onChangedCity, countryId: 191);
      },
    );
  }

  void showFilterPrice() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return PriceFilterModal(onChangedPrice: onChangedPrice);
      },
    );
  }

  void onChangedPrice(Map value) {
    widget.onChanged("update");
  }

  void onChangedCity(Map value) {
    final filterData = Provider.of<AdFilterProvider>(context, listen: false);
    filterData.filterData = {"city_id_value": value, "city_id": value['id']};
    widget.onChanged("update");
  }

  Widget PriceWidget(Map data) {
    if (data.containsKey("price_from") && data.containsKey("price_to")) {
      return Row(children: [
        Text(
            "${priceFormat(data['price_from'])} ₸ - ${priceFormat(data['price_to'])} ₸"),
      ]);
    } else if (data.containsKey("price_from")) {
      return Text("от ${priceFormat(data['price_from'])} ₸");
    } else if (data.containsKey("price_to")) {
      return Text("до ${priceFormat(data['price_to'])} ₸");
    } else {
      return const Text("Цена");
    }
  }

  void showFilterPage() {
    showCupertinoModalBottomSheet(
            context: context,
            enableDrag: false,
            builder: (context) => FilterAdListPage(
                categoryId: widget.category['id'],
                data: widget.category['options']['necessary_inputs']))
        .then(filteredAds);
  }

  void filteredAds(value) {
    if (value != null) widget.onChanged("update");
  }

  @override
  Widget build(BuildContext context) {
    final filterData = Provider.of<AdFilterProvider>(context, listen: false);
    return Consumer<AdFilterProvider>(builder: (context, data, child) {
      bool activeCity = data.data.containsKey("city_id");
      bool price = data.data.containsKey("price_from") ||
          data.data.containsKey("price_to");
      print(data.data);
      return AppBar(
        leadingWidth: MediaQuery.of(context).size.width - 100,
        actions: [
          FilterButton(
          showFilterPage: showFilterPage,
          fromPage: '',
        )
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
            title: widget.category['title'],
            onPressed: () => Navigator.pop(context)),
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 46),
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2, color: Color(0xfff4f5f7)))),
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
                              left: 12, right: activeCity ? 6 : 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: activeCity
                                      ? ColorComponent.mainColor
                                      : const Color(0xffD1D5DB)),
                              color: ColorComponent.gray['50']),
                          child: Row(
                            children: [
                              Text(
                                  activeCity
                                      ? data.data['city_id_value']['title']
                                      : "Все города",
                                  style: TextStyle(
                                      color: activeCity
                                          ? Colors.black
                                          : ColorComponent.gray['500'])),
                              const Divider(indent: 6),
                              activeCity
                                  ? GestureDetector(
                                      onTap: () {
                                        filterData.removeData = "city_id";
                                        filterData.removeData = "city_id_value";
                                        widget.onChanged("update");
                                      },
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
                    GestureDetector(
                      onTap: showFilterPrice,
                      child: Container(
                          height: 36,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 2),
                          padding:
                              EdgeInsets.only(left: 12, right: price ? 6 : 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: !price
                                      ? const Color(0xffD1D5DB)
                                      : ColorComponent.mainColor),
                              color: ColorComponent.gray['50']),
                          child: price
                              ? Row(children: [
                                  PriceWidget(data.value),
                                  const Divider(indent: 6),
                                  GestureDetector(
                                      onTap: () {
                                        filterData.removeData = "price_from";
                                        filterData.removeData = "price_to";
                                        widget.onChanged("update");
                                      },
                                      child: Container(
                                          width: 24,
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                              'assets/icons/close.svg',
                                              color: Colors.black)))
                                ])
                              : Row(
                                  children: [
                                    Text("Цена",
                                        style: TextStyle(
                                            color: ColorComponent.gray['500'])),
                                    const Divider(indent: 6),
                                    SvgPicture.asset('assets/icons/down.svg')
                                  ],
                                )),
                    ),
                  ],
                ))),
      );
    });
  }
}

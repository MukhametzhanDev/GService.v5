import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterButton.dart';
import 'package:gservice5/pages/ad/filter/priceFilterModal.dart';
import 'package:gservice5/pages/application/filter/filterApplicationListPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FilterApplicationWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final AppBar appBar;
  final void Function(String value) onChanged;
  const FilterApplicationWidget(
      {super.key, required this.appBar, required this.onChanged});

  @override
  State<FilterApplicationWidget> createState() =>
      _FilterApplicationWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height + 46);
}

class _FilterApplicationWidgetState extends State<FilterApplicationWidget> {
  Map city = {};
  Map price = {};

  final analytics = GetIt.I<FirebaseAnalytics>();

  @override
  void initState() {
    addData();
    super.initState();
  }

  void addData() {
    bool hasCity = FilterData.data.containsKey("city_id_value");
    bool hasPriceTo = FilterData.data.containsKey("price_to");
    bool hasPriceFrom = FilterData.data.containsKey("price_from");
    if (hasCity) {
      city = FilterData.data['city_id_value'] ?? {};
    } else {
      onClearCity();
    }
    if (hasPriceTo) {
      price['price_to'] = FilterData.data['price_to'];
    } else {
      FilterData.data.remove("price_to");
    }
    if (hasPriceFrom) {
      price['price_from'] = FilterData.data['price_from'];
    } else {
      FilterData.data.remove("price_from");
    }
    setState(() {});
    widget.onChanged("update");
  }

  void showCityList() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Cities(
          onPressed: onChangedCity,
          countryId: 191,
        );
      },
    );

    analytics.logEvent(
        name: GAEventName.buttonClick,
        parameters: {GAKey.buttonName: GAParams.btnCity}).catchError((e) {
      if (kDebugMode) {
        debugPrint(e);
      }
    });
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
    price = value;
    FilterData.data.addAll(Map<String, dynamic>.from(value));
    setState(() {});
    widget.onChanged("update");
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

  void onClearPrice() {
    price.clear();
    FilterData.data.remove("price_from");
    FilterData.data.remove("price_to");
    setState(() {});
    widget.onChanged("update");
  }

  Widget PriceWidget() {
    Map price = FilterData.data;
    if (price.containsKey("price_from") && price.containsKey("price_to")) {
      return Row(children: [
        Text(
            "${priceFormat(price['price_from'])} ₸ - ${priceFormat(price['price_to'])} ₸"),
      ]);
    } else if (price.containsKey("price_from")) {
      return Text("от ${priceFormat(price['price_from'])} ₸");
    } else if (price.containsKey("price_to")) {
      return Text("до ${priceFormat(price['price_to'])} ₸");
    } else {
      return const Text("Цена");
    }
  }

  void showFilterPage() {
    showCupertinoModalBottomSheet(
            context: context,
            enableDrag: false,
            builder: (context) => const FilterApplicationListPage())
        .then(filteredAds);

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.btnApplicationFilter,
      GAKey.screenName: GAParams.applicationPage
    });
  }

  void filteredAds(value) {
    if (value != null) {
      addData();
    }
  }

  // void

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: MediaQuery.of(context).size.width - 100,
      actions: [
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
        //     child: SvgPicture.asset("assets/icons/bellOutline.svg", width: 20),
        //   ),
        // ),
        FilterButton(showFilterPage: showFilterPage)
      ],
      leading: BackTitleButton(
          title: "Заказы", onPressed: () => Navigator.pop(context)),
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
                  GestureDetector(
                    onTap: showFilterPrice,
                    child: Container(
                        height: 36,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 2),
                        padding: EdgeInsets.only(
                            left: 12, right: price.isNotEmpty ? 6 : 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1,
                                color: price.isEmpty
                                    ? const Color(0xffD1D5DB)
                                    : ColorComponent.mainColor),
                            color: ColorComponent.gray['50']),
                        child: price.isNotEmpty
                            ? Row(children: [
                                PriceWidget(),
                                const Divider(indent: 6),
                                GestureDetector(
                                    onTap: onClearPrice,
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
  }
}

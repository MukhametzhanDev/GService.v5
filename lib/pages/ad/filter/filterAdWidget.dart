import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterButton.dart';
import 'package:gservice5/pages/ad/filter/priceFilterModal.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FilterAdWidget extends StatefulWidget {
  final Function(String title) onChanged;
  const FilterAdWidget({super.key, required this.onChanged});

  @override
  State<FilterAdWidget> createState() => _FilterAdWidgetState();
}

class _FilterAdWidgetState extends State<FilterAdWidget> {
  Map city = {};
  Map price = {};
  Map category = {};

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
        return Cities(onPressed: onChangedCity, countryId: 191);
      },
    );
  }

  void showFilterPrice() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return PriceFilterModal(onChangedPrice: onChangedPrice, value: price);
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
    // showCupertinoModalBottomSheet(
    //         context: context,
    //         enableDrag: false,
    //         builder: (context) => FilterAdListPage(
    //             data: widget.category['options']['necessary_inputs']))
    //     .then(filteredAds);
  }

  void filteredAds(value) {
    if (value != null) {
      addData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Divider(indent: 15),
          GestureDetector(
            onTap: showCityList,
            child: Container(
                height: 36,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 12),
                padding:
                    EdgeInsets.only(left: 12, right: city.isNotEmpty ? 6 : 12),
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
                padding:
                    EdgeInsets.only(left: 12, right: price.isNotEmpty ? 6 : 12),
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
                              style:
                                  TextStyle(color: ColorComponent.gray['500'])),
                          const Divider(indent: 6),
                          SvgPicture.asset('assets/icons/down.svg')
                        ],
                      )),
          ),
          Divider(indent: 12),
          GestureDetector(
            onTap: showFilterPrice,
            child: Container(
                height: 36,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 2),
                padding:
                    EdgeInsets.only(left: 12, right: price.isNotEmpty ? 6 : 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1,
                        color: category.isEmpty
                            ? const Color(0xffD1D5DB)
                            : ColorComponent.mainColor),
                    color: ColorComponent.gray['50']),
                child: Row(
                  children: [
                    Text("Все категория",
                        style: TextStyle(color: ColorComponent.gray['500'])),
                    const Divider(indent: 6),
                    SvgPicture.asset('assets/icons/down.svg')
                  ],
                )),
          )
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/priceFilterModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SortAdWidget extends StatefulWidget {
  final void Function(Map? value) onChanged;
  const SortAdWidget({super.key, required this.onChanged});

  @override
  State<SortAdWidget> createState() => _SortAdWidgetState();
}

class _SortAdWidgetState extends State<SortAdWidget> {
  Map city = {};
  Map price = {};
  Map param = {};

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
    param = Map<String, dynamic>.from(value);
    widget.onChanged(param);
    setState(() {});
  }

  void onChangedCity(Map value) {
    print("CITY ----> $value");
    city = value;
    param = Map<String, dynamic>.from({"city_id": value['id']});
    widget.onChanged(param);
    setState(() {});
  }

  void onClearCity() {
    city.clear();
    param.remove("city_id");
    widget.onChanged(param);
    setState(() {});
  }

  void onClearPrice() {
    price.clear();
    param.remove("price_from");
    param.remove("price_to");
    widget.onChanged(param);
    setState(() {});
  }

  Widget PriceWidget() {
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
      return Text("Цена");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: showCityList,
          child: Container(
              height: 36,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 12),
              padding:
                  EdgeInsets.only(left: 12, right: city.isNotEmpty ? 6 : 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1,
                      color: city.isNotEmpty
                          ? ColorComponent.mainColor
                          : Color(0xffD1D5DB)),
                  color: ColorComponent.gray['50']),
              child: Row(
                children: [
                  Text(city.isNotEmpty ? city['title'] : "Все города",
                      style: TextStyle(
                          color: city.isNotEmpty
                              ? Colors.black
                              : ColorComponent.gray['500'])),
                  Divider(indent: 6),
                  city.isNotEmpty
                      ? GestureDetector(
                          onTap: onClearCity,
                          child: Container(
                              width: 24,
                              alignment: Alignment.center,
                              child: SvgPicture.asset('assets/icons/close.svg',
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
              margin: EdgeInsets.only(bottom: 2),
              padding:
                  EdgeInsets.only(left: 12, right: price.isNotEmpty ? 6 : 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1, color: Color(0xffD1D5DB)),
                  color: ColorComponent.gray['50']),
              child: price.isNotEmpty
                  ? Row(children: [
                      PriceWidget(),
                      Divider(indent: 6),
                      GestureDetector(
                          onTap: onClearPrice,
                          child: Container(
                              width: 24,
                              alignment: Alignment.center,
                              child: SvgPicture.asset('assets/icons/close.svg',
                                  color: Colors.black)))
                    ])
                  : Row(
                      children: [
                        Text("Цена",
                            style:
                                TextStyle(color: ColorComponent.gray['500'])),
                        Divider(indent: 6),
                        SvgPicture.asset('assets/icons/down.svg')
                      ],
                    )),
        ),
      ],
    );
  }
}

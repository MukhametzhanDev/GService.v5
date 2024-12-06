import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/modal/cities.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SortAdWidget extends StatefulWidget {
  final void Function(Map? value) onChangedCity;
  const SortAdWidget({super.key, required this.onChangedCity});

  @override
  State<SortAdWidget> createState() => _SortAdWidgetState();
}

class _SortAdWidgetState extends State<SortAdWidget> {
  Map city = {};

  void showCityList() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Cities(onPressed: onChangedCity, countryId: 191);
      },
    );
  }

  void onChangedCity(Map value) {
    city = value;
    widget.onChangedCity(value);
    setState(() {});
  }

  void onClearCity() {
    city.clear();
    widget.onChangedCity({});
    setState(() {});
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
        Container(
            height: 36,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 2),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Color(0xffD1D5DB)),
                color: ColorComponent.gray['50']),
            child: Row(
              children: [
                Text("Цена",
                    style: TextStyle(color: ColorComponent.gray['500'])),
                Divider(indent: 6),
                SvgPicture.asset('assets/icons/down.svg')
              ],
            )),
      ],
    );
  }
}

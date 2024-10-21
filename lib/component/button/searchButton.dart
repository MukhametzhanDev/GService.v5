import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: ColorComponent.gray['50'],
          border: Border.all(width: 1, color: Color(0xffE5E7EB)),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/searchOutline.svg'),
          Divider(indent: 8),
          Text(
            "Поиск по GService",
            style: TextStyle(color: ColorComponent.gray['500']),
          )
        ],
      ),
    );
  }
}

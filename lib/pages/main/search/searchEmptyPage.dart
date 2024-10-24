import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class SearchEmptyPage extends StatefulWidget {
  const SearchEmptyPage({super.key});

  @override
  State<SearchEmptyPage> createState() => _SearchEmptyPageState();
}

class _SearchEmptyPageState extends State<SearchEmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: ColorComponent.gray['200']),
              child: SvgPicture.asset('assets/icons/search.svg',
                  width: 40, height: 40)),
          const SizedBox(height: 16),
          Text("По данному запросу ничего не найлено",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorComponent.gray['500'])),
          const SizedBox(height: 16),
          Text(
              "Оставьте заявку с этими характеристиками и найдите то, что вам нужно",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorComponent.gray['500']),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  backgroundColor: ColorComponent.mainColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              child: const Text("Создать заявку",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white)))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ApplicationListMain extends StatefulWidget {
  const ApplicationListMain({super.key});

  @override
  State<ApplicationListMain> createState() => _ApplicationListMainState();
}

class _ApplicationListMainState extends State<ApplicationListMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text("Заявки на спецтехнику",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, height: 1)),
        ),
        Divider(indent: 12),
        SizedBox(
          height: 110,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: Row(
                children: [1, 2, 3].map((value) {
                  return Container(
                    height: 110,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.6),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Color(0xffeeeeee))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Нужен экскаватор 2-ух кубовый",
                          style: TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(priceFormat(0),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/pin.svg',
                                      width: 16,
                                      color: ColorComponent.gray['500']),
                                  Divider(indent: 4),
                                  Text(
                                    "г. Алматы",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorComponent.gray['500'],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Text("15 Сент.",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorComponent.gray['500'])),
                            ])
                      ],
                    ),
                  );
                }).toList(),
              )),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 41,
          child: Button(
              onPressed: () {},
              padding: EdgeInsets.symmetric(horizontal: 15),
              backgroundColor: ColorComponent.mainColor.withOpacity(.1),
              title: "Смотреть еще 1 234 заявок"),
        )
      ],
    );
  }
}

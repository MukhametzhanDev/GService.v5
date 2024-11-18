import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:readmore/readmore.dart';

class ShowDescriptionWidget extends StatelessWidget {
  const ShowDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Описание",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      Divider(height: 8),
      ReadMoreText(
        "Вниманию всех потенциальных клиентов и заинтересованных лиц в Республике Казахстан: ТОО ZOOMLION Central Asia является исключительным правообладателем товарного знака ZOOMLION на территории Республики правообладателем товарного знака ZOOMLION на территории Республики правообладателем товарного знака ZOOMLION на территории Республики",
        trimMode: TrimMode.Line,
        trimLines: 5,
        trimCollapsedText: 'еще',
        trimExpandedText: '',
        moreStyle: TextStyle(
            fontSize: 14,
            height: 1.8,
            color: ColorComponent.blue['600'],
            fontWeight: FontWeight.w500),
      ),
    ]);
  }
}

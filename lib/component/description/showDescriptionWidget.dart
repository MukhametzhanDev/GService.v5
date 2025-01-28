import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:readmore/readmore.dart';

class ShowDescriptionWidget extends StatelessWidget {
  final String desc;
  const ShowDescriptionWidget({super.key, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Описание",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const Divider(height: 8),
      ReadMoreText(
        desc,
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
      // GestureDetector(
      //     child: Padding(
      //   padding: const EdgeInsets.only(top: 4),
      //   child: Text(
      //     "Перевести",
      //     style: TextStyle(
      //         color: ColorComponent.blue['500'],
      //         fontWeight: FontWeight.w500,
      //         fontSize: 13),
      //   ),
      // ))
    ]);
  }
}


// Container(
//             decoration: BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Row(children: [
//               Expanded(
//                   child: Text(
//                 "$title: " ?? "",
//                 style: TextStyle(color: ColorComponent.gray['500']),
//               )),
//               Expanded(
//                   child: Text(subTitle ?? "",
//                       style: TextStyle(fontWeight: FontWeight.w600)))
//             ]),
//           )
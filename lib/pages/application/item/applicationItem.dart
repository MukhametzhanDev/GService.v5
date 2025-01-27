import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/favoriteApplicationButton.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/viewApplicationPage.dart';

class ApplicationItem extends StatefulWidget {
  final Map data;
  const ApplicationItem({super.key, required this.data});

  @override
  State<ApplicationItem> createState() => _ApplicationItemState();
}

class _ApplicationItemState extends State<ApplicationItem> {
  void showPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewApplicationPage(id: widget.data['id'])));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showPage,
      // onLongPress: () {
      //   onLongPressShowNumber(data, context);
      // },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
        padding: const EdgeInsets.only(left: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Divider(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(widget.data['title'].toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorComponent.blue['700'])),
              ),
              const Divider(indent: 12),
              FavoriteApplicationButton(data: widget.data)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 8),

              Text(priceFormatted(widget.data['price']?['price'], context),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              // Row(
              //   children: [
              //     Expanded(
              //         child: Text(priceFormat(data['price']),
              //             style: TextStyle(
              //                 fontSize: 16, fontWeight: FontWeight.w600))),
              //     Container(
              //         padding: EdgeInsets.symmetric(horizontal: 6),
              //         alignment: Alignment.center,
              //         height: 24,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(6),
              //             color: ColorComponent.mainColor),
              //         child: Text(data['category']['title'],
              //             style: TextStyle(
              //                 fontSize: 12, fontWeight: FontWeight.w600))),
              //   ],
              // ),
              const Divider(height: 10),
              Text(
                widget.data['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(height: 12),
              Row(children: [
                SvgPicture.asset("assets/icons/pin.svg",
                    width: 16, color: ColorComponent.gray['500']),
                const Divider(indent: 4),
                Text(widget.data['city']['title'],
                    style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.3500,
                        color: ColorComponent.gray['500'])),
                const Divider(indent: 12),
                Text(formattedDate(widget.data['created_at'], "dd MMM HH:MM"),
                    // "15 Сент 04:20",
                    style: TextStyle(
                        fontSize: 12, color: ColorComponent.gray['500'])),
                Expanded(child: Container()),
                Row(children: [
                  SvgPicture.asset("assets/icons/eye.svg"),
                  const Divider(indent: 4),
                  Text(widget.data['statistics']['viewed'].toString(),
                      style: TextStyle(
                          fontSize: 12, color: ColorComponent.gray['500']))
                ])
              ]),
              const Divider(height: 16),
            ]),
          ),
        ]),
      ),
    );
  }
}

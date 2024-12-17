import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/viewApplicationPage.dart';
import 'package:gservice5/pages/favorite/application/data/favoriteApplicationData.dart';

class ApplicationItem extends StatefulWidget {
  final Map data;
  final bool showCategory;
  const ApplicationItem(
      {super.key, required this.data, required this.showCategory});

  @override
  State<ApplicationItem> createState() => _ApplicationItemState();
}

class _ApplicationItemState extends State<ApplicationItem> {
  void showPage() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewApplicationPage(id: widget.data['id'])))
        .then(verifyFavoriteApplication);
  }

  void verifyFavoriteApplication(value) {
    bool active = FavoriteApplicationData.applicationFavorite
        .containsKey(widget.data['id']);
    widget.data['is_favorite'] = active;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showPage,
      // onLongPress: () {
      //   onLongPressShowNumber(data, context);
      // },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(widget.data['title'].toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorComponent.blue['700'])),
              ),
              Divider(indent: 12),
              FavoriteButton(
                  id: widget.data['id'],
                  active: widget.data['is_favorite'],
                  type: "application")
            ],
          ),
          Divider(height: 8),
          Text(priceFormat(widget.data['price']),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
          Divider(height: 10),
          Text(
            widget.data['description'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(height: 12),
          Row(children: [
            SvgPicture.asset("assets/icons/pin.svg",
                width: 16, color: ColorComponent.gray['500']),
            Divider(indent: 4),
            Text(widget.data['city']['title'],
                style: TextStyle(
                    fontSize: 12,
                    // fontWeight: FontWeight.3500,
                    color: ColorComponent.gray['500'])),
            Divider(indent: 12),
            Text(formattedDate(widget.data['created_at'], "dd MMM HH:MM"),
                // "15 Сент 04:20",
                style:
                    TextStyle(fontSize: 12, color: ColorComponent.gray['500'])),
            Expanded(child: Container()),
            Row(children: [
              SvgPicture.asset("assets/icons/eye.svg"),
              Divider(indent: 4),
              Text(widget.data['statistics']['viewed'].toString(),
                  style: TextStyle(
                      fontSize: 12, color: ColorComponent.gray['500']))
            ])
          ]),
          Divider(height: 16),
        ]),
      ),
    );
  }
}

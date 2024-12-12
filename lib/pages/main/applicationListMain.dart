import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/list/applicationListPage.dart';
import 'package:gservice5/pages/application/item/smallApplicationItem.dart';
import 'package:gservice5/pages/application/viewApplicationPage.dart';

class ApplicationListMain extends StatefulWidget {
  const ApplicationListMain({super.key});

  @override
  State<ApplicationListMain> createState() => _ApplicationListMainState();
}

class _ApplicationListMainState extends State<ApplicationListMain> {
  List data = [1, 2, 3];
  void showPage(id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ViewApplicationPage(id: 0)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("1 234 Заявки на спецтехнику",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, height: 1)),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApplicationListPage()));
                  },
                  child: SvgPicture.asset('assets/icons/right.svg')
                  //  Container(
                  //     height: 32,
                  //     padding: EdgeInsets.symmetric(horizontal: 12),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(8),
                  //         color: ColorComponent.mainColor.withOpacity(.2)),
                  //     child: Text("Все",
                  //         style: TextStyle(
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w600,
                  //             height: 1))),
                  )
            ],
          ),
        ),
        Divider(height: 18),
        SizedBox(
          height: 110,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: Row(
                children: data.map((value) {
                  int index = data.indexOf(value);
                  if (index == data.length - 1) {
                    return Row(
                      children: [
                        SmallApplicationItem(
                            onPressed: showPage, data: {}, position: "main"),
                        ShowMoreApplicaiton()
                      ],
                    );
                  }
                  return SmallApplicationItem(
                      onPressed: showPage, data: {}, position: "main");
                }).toList(),
              )),
        ),
      ],
    );
  }
}

class ShowMoreApplicaiton extends StatelessWidget {
  const ShowMoreApplicaiton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ApplicationListPage()));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 166,
          height: 122,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorComponent.mainColor.withOpacity(.1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/searchOutline.svg", width: 32),
              Divider(height: 4),
              Text(
                "еще 12 000\nзаявок",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}

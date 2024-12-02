import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/applicationItem.dart';

class ApplicationListPage extends StatefulWidget {
  const ApplicationListPage({super.key});

  @override
  State<ApplicationListPage> createState() => _ApplicationListPageState();
}

class _ApplicationListPageState extends State<ApplicationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(children: [
                  SizedBox(height: 12),
                  SizedBox(
                      height: 40,
                      child: Row(children: [
                        Expanded(
                            child: Button(
                          onPressed: () {},
                          title: "Весь Казахстан",
                          icon: "pin.svg",
                          backgroundColor: ColorComponent.blue['100'],
                          titleColor: ColorComponent.blue['500'],
                        )),
                        Divider(indent: 12),
                        Expanded(
                            child: Button(
                          onPressed: () {},
                          title: "Фильтр",
                          icon: "filter.svg",
                          backgroundColor:
                              ColorComponent.mainColor.withOpacity(.1),
                        ))
                      ])),
                  SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                        child: Text("12 000 объявлений",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600))),
                    Row(
                      children: [
                        Text("По умолчанию",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue)),
                        Divider(indent: 4),
                        SvgPicture.asset("assets/icons/sort.svg")
                      ],
                    ),
                  ]),
                  SizedBox(height: 12),
                ])),
            // Expanded(
            //     child: ListView.builder(
            //         padding: EdgeInsets.symmetric(vertical: 16),
            //         itemCount: 10,
            //         itemBuilder: (context, int index) {
            //           return ApplicationItem(index: index);
            //         }))
          ],
        ));
  }
}

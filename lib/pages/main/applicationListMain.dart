import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/list/customer/applicationListPage.dart';
import 'package:gservice5/pages/application/item/smallApplicationItem.dart';
import 'package:gservice5/pages/application/viewApplicationPage.dart';
import 'package:gservice5/pages/create/application/sectionCreateApplicationPage.dart';

class ApplicationListMain extends StatefulWidget {
  final List data;
  const ApplicationListMain({super.key, required this.data});

  @override
  State<ApplicationListMain> createState() => _ApplicationListMainState();
}

class _ApplicationListMainState extends State<ApplicationListMain> {
  final analytics = GetIt.I<FirebaseAnalytics>();

  void showPage(id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ViewApplicationPage(id: id)));

    analytics.logSelectContent(
        contentType: GAContentType.application,
        itemId: id.toString(),
        parameters: {
          GAKey.title: widget.data.firstWhere((e) => e['id'] == id,
                  orElse: () => '')['title'] ??
              '',
          GAKey.screenName: GAParams.mainPage
        }).catchError((e) => debugPrint(e));
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
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ApplicationListPage()));

                    analytics.logEvent(
                        name: GAEventName.buttonClick,
                        parameters: {
                          GAKey.buttonName: GAParams.txtBtnPlaceOrder,
                          GAKey.screenName: GAParams.mainPage
                        });
                  },
                  child: const Text("Заказы на спецтехнику",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1))),
              // SvgPicture.asset('assets/icons/right.svg')
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SectionCreateApplicationPage()))
                        .then((value) {
                      if (value == "application") {
                        Navigator.pushNamed(context, "MyApplicationListPage");
                      }
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        color: ColorComponent.blue['100'],
                        borderRadius: BorderRadius.circular(4)),
                    child: Text("Разместить заказ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: ColorComponent.blue['600'])),
                  ))
            ],
          ),
        ),
        const Divider(height: 18),
        SizedBox(
          height: 110,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Row(
                children: widget.data.map((value) {
                  int index = widget.data.indexOf(value);
                  if (index == widget.data.length - 1) {
                    return Row(
                      children: [
                        SmallApplicationItem(
                            onPressed: showPage, data: value, position: "main"),
                        const ShowMoreApplicaiton()
                      ],
                    );
                  }
                  return SmallApplicationItem(
                      onPressed: showPage, data: value, position: "main");
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
    final analytics = GetIt.I<FirebaseAnalytics>();

    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ApplicationListPage()));
          analytics.logEvent(name: GAEventName.buttonClick, parameters: {
            GAKey.buttonName: GAParams.btnMoreOder
          }).catchError((e) => debugPrint(e));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
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
              const Divider(height: 4),
              const Text(
                "еще 12 000\nзаявок",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/list/applicationListPage.dart';
import 'package:gservice5/pages/application/item/smallApplicationItem.dart';
import 'package:gservice5/pages/application/viewApplicationPage.dart';

class ApplicationListMain extends StatefulWidget {
  final List data;
  const ApplicationListMain({super.key, required this.data});

  @override
  State<ApplicationListMain> createState() => _ApplicationListMainState();
}

class _ApplicationListMainState extends State<ApplicationListMain> {
  void showPage(id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ViewApplicationPage(id: id)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ApplicationListPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Заявки на спецтехнику",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600, height: 1)),
                SvgPicture.asset('assets/icons/right.svg')
              ],
            ),
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
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ApplicationListPage()));
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

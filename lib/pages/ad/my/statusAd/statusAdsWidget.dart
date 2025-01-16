import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/provider/myAdFilterProvider.dart';
import 'package:gservice5/provider/statusMyAdCountProvider.dart';
import 'package:provider/provider.dart';

class StatusAdsWidget extends StatefulWidget {
  final Map? data;
  const StatusAdsWidget({super.key, this.data});

  @override
  State<StatusAdsWidget> createState() => _StatusAdsWidgetState();
}

class _StatusAdsWidgetState extends State<StatusAdsWidget> {
  final List _tabs = [
    {"title": "Активные", "type": "pending"},
    {"title": "В архвие", "type": "archived"},
    {"title": "Удаленное", "type": "deleted"}
  ];
  int currentIndex = 0;

  @override
  void initState() {
    getCount();
    super.initState();
  }

  void getCount() {
    int id = Provider.of<MyAdFilterProvider>(context, listen: false)
        .currentCategoryId;
    Provider.of<StatusMyAdCountProvider>(context, listen: false).getData(id);
  }

  void changeType(Map value, index) {
    print(value);
    Provider.of<MyAdFilterProvider>(context, listen: false).addFilter = {
      "status": value['type']
    };
    // UpdateAds.addValue = {"status": value['type']};
    currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        child:
            Consumer<StatusMyAdCountProvider>(builder: (context, data, child) {
          return Row(
              children: _tabs.map((value) {
            int index = _tabs.indexOf(value);
            bool active = index == currentIndex;
            return GestureDetector(
              onTap: () {
                changeType(value, index);
              },
              child: Container(
                  height: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: active ? const Color(0xffF4F4F4) : Colors.white),
                  child: Row(
                    children: [
                      Text(value['title']),
                      const Divider(indent: 10),
                      data.loading
                          ? Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorComponent.gray['100']),
                            )
                          : Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      ColorComponent.mainColor.withOpacity(.4)),
                              child: Text(
                                data.value[value['type']].toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            )
                    ],
                  )),
            );
          }).toList());
        }),
      ),
    );
  }
}

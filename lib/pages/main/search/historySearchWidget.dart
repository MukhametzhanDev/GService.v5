import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/data/cache/cacheSearchTitleData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistorySearchWidget extends StatefulWidget {
  final TextEditingController titleController;
  final Function getResult;

  const HistorySearchWidget(
      {super.key, required this.titleController, required this.getResult});

  @override
  State<HistorySearchWidget> createState() => _HistorySearchWidgetState();
}

class _HistorySearchWidgetState extends State<HistorySearchWidget> {
  List<String> history = [];
  List<String> historyFilter = [];

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
    widget.titleController.addListener(() {
      filterTitle();
    });
  }

  void filterTitle() {
    if (widget.titleController.text.length > 2) {
      if (history.isNotEmpty) {
        List<String> filterTitle = history
            .where((String item) => item
                .toLowerCase()
                .contains(widget.titleController.text.toLowerCase()))
            .toList();
        historyFilter = filterTitle;
        setState(() {});
      }
    } else if (widget.titleController.text.isEmpty) {
      historyFilter = history;
      setState(() {});
    }
  }

  Future<void> _loadHistoryData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = (prefs.getStringList('historyData') ?? []);
      historyFilter = (prefs.getStringList('historyData') ?? []);
    });
  }

  void clearHistoryData() {
    CacheSearchTitleData.removeHistoryData();
    history = [];
    historyFilter = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return historyFilter.isEmpty
        ? Container()
        : Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(color: ColorComponent.gray['300']),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ранее искали",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorComponent.gray['500']),
                    ),
                    TextButton(
                        onPressed: clearHistoryData,
                        child: Text(
                          "Очистить",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorComponent.blue['500']),
                        ))
                  ],
                ),
              ),
              Column(
                children: historyFilter.map((value) {
                  return Container(
                      // decoration: BoxDecoration(
                      //     border: Border(
                      //         bottom: BorderSide(
                      //             width: 1, color: ColorComponent.gray200))),
                      child: ListTile(
                    onTap: () {
                      widget.getResult(value);
                    },
                    contentPadding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 16, right: 8),
                    leading:
                        SvgPicture.asset('assets/icons/search.svg', width: 18),
                    title: Text(value,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                    trailing: Container(
                      width: 40,
                      child: TextButton(
                          onPressed: () {
                            CacheSearchTitleData.removeTitle(value);
                            _loadHistoryData();
                          },
                          child: SvgPicture.asset('assets/icons/close.svg')),
                    ),
                  ));
                }).toList(),
              ),
              // SizedBox(height: MediaQuery.of(context).padding.bottom)
            ],
          );
  }
}

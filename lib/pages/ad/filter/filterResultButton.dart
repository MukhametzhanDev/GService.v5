import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:provider/provider.dart';

class FilterResultButton extends StatefulWidget {
  final int categoryId;
  const FilterResultButton({super.key, required this.categoryId});

  @override
  State<FilterResultButton> createState() => _FilterResultButtonState();
}

class _FilterResultButtonState extends State<FilterResultButton> {
  var adFilter = AdFilterProvider();
  int count = 0;

  @override
  void initState() {
    getCount();
    super.initState();
  }

  void getCount() async {
    await Provider.of<AdFilterProvider>(context, listen: false).getCountAd();
  }

  // @override
  // void dispose() {
  //   adFilter.removeListener(getCountResult);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdFilterProvider>(builder: (context, data, child) {
      print("data.countValue ${data.countValue}");
      return Button(
        onPressed: () {
          Navigator.pop(context, "update");
        },
        title: "Показать (${data.countValue})",
        padding: const EdgeInsets.symmetric(horizontal: 15),
      );
    });
  }
}

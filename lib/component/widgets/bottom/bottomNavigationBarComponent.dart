import 'package:flutter/material.dart';

class BottomNavigationBarComponent extends StatelessWidget {
  final Widget child;
  const BottomNavigationBarComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: EdgeInsets.only(
                  top: 12, bottom: MediaQuery.of(context).padding.bottom + 15),
              color: Colors.white,
              child: child)
        ]));
  }
}

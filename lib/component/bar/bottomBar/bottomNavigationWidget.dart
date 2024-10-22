import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final Widget child;
  const BottomNavigationBarWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  top: 12, bottom: MediaQuery.of(context).padding.bottom + 15),
              child: child)
        ]));
  }
}

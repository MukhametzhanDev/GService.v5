import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';

class LeaveOrderPage extends StatefulWidget {
  final Map data;
  const LeaveOrderPage({super.key, required this.data});

  @override
  State<LeaveOrderPage> createState() => _LeaveOrderPageState();
}

class _LeaveOrderPageState extends State<LeaveOrderPage> {
  Map data = {};

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [CloseIconButton(iconColor: null, padding: true)]),
      body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Column(children: [
            
          ])),
    );
  }
}

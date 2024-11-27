import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';

class StructureEditAdPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const StructureEditAdPage({super.key, required this.data});

  @override
  State<StructureEditAdPage> createState() => _StructureEditAdPageState();
}

class _StructureEditAdPageState extends State<StructureEditAdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackIconButton(), title: Text("Редактирование")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}

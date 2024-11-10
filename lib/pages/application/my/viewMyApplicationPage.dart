import 'package:flutter/material.dart';

class ViewMyApplicationPage extends StatefulWidget {
  final int id;
  const ViewMyApplicationPage({super.key, required this.id});

  @override
  State<ViewMyApplicationPage> createState() => _ViewMyApplicationPageState();
}

class _ViewMyApplicationPageState extends State<ViewMyApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("енды истейм"),),
    );
  }
}

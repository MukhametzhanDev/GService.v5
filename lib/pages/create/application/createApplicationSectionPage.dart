import 'package:flutter/material.dart';


class CreateApplicationSectionPage extends StatefulWidget {
  const CreateApplicationSectionPage({super.key});

  @override
  State<CreateApplicationSectionPage> createState() =>
      _CreateApplicationSectionPageState();
}

class _CreateApplicationSectionPageState
    extends State<CreateApplicationSectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [Text("Укажите о чем будет ваще объявление")],
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
@RoutePage()
class ViewRafflePage extends StatefulWidget {
  const ViewRafflePage({super.key});

  @override
  State<ViewRafflePage> createState() => _ViewRafflePageState();
}

class _ViewRafflePageState extends State<ViewRafflePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Raffle"),
      ),
    );
  }
}

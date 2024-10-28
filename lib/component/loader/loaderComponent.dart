import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget {
  const LoaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    ));
  }
}

class LoaderPaginationComponent extends StatelessWidget {
  const LoaderPaginationComponent({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(color: Colors.blue)),
    );
  }
}

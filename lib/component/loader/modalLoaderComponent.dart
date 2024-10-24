import 'package:flutter/material.dart';

void showModalLoader(context) {
  FocusManager.instance.primaryFocus?.unfocus();
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ModalLoaderComponent();
      });
}

class ModalLoaderComponent extends StatelessWidget {
  const ModalLoaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }
}

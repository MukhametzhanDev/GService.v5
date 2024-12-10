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
    return Center(
        child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircularProgressIndicator(color: Colors.white)));
  }
}

void showModalImageLoader(context) {
  FocusManager.instance.primaryFocus?.unfocus();
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ModalImageLoaderComponent();
      });
}

class ModalImageLoaderComponent extends StatelessWidget {
  const ModalImageLoaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: Colors.white),
        Divider(indent: 15),
        Text("Загрузка изоброжении",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))
      ],
    );
  }
}

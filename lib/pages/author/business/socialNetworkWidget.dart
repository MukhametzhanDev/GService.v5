import 'package:flutter/material.dart';

class SocialNetworkWidget extends StatelessWidget {
  final List data;
  const SocialNetworkWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Container()
        : Column(children: [
            const Text("Контакты",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            const Divider(height: 10),
            GestureDetector(
              child: const Row(children: [
                Text("example.com",
                    style: TextStyle(decoration: TextDecoration.underline))
              ]),
            ),
            const Divider(height: 12),
            GestureDetector(
              child: const Row(children: [
                Text("Написать на whatsapp",
                    style: TextStyle(decoration: TextDecoration.underline))
              ]),
            ),
            const Divider(height: 12),
            GestureDetector(
              child: const Row(children: [
                Text("@instagramnik",
                    style: TextStyle(decoration: TextDecoration.underline))
              ]),
            ),
          ]);
  }
}
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class SnackBarComponent {
  void showDoneMessage(String title, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            SvgPicture.asset('assets/icons/info.svg',
                color: ColorComponent.blue['500']),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 3000),
        padding: const EdgeInsets.all(12),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorComponent.blue['500']!, width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void showErrorMessage(String title, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            SvgPicture.asset('assets/icons/info.svg',
                color: ColorComponent.red['700']),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 2000),
        padding: const EdgeInsets.all(12),
        elevation: 1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xfff05252), width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void showResponseErrorMessage(Response response, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            SvgPicture.asset('assets/icons/info.svg',
                color: ColorComponent.red['700']),
            const SizedBox(width: 10),
            Expanded(
              child: Text(response.data['message'],
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 2000),
        padding: const EdgeInsets.all(12),
        elevation: 1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xfff05252), width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void showServerErrorMessage(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            SvgPicture.asset('assets/icons/info.svg',
                color: ColorComponent.red['700']),
            const SizedBox(width: 10),
            const Text("Что-то пошло не так",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ],
        ),
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.all(12),
        elevation: 1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xfff05252), width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void showNotGoBackServerErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            SvgPicture.asset('assets/icons/info.svg',
                color: ColorComponent.red['500']),
            const SizedBox(width: 10),
            const Text("Что-то пошло не так",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ],
        ),
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.all(12),
        elevation: 1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xfff05252), width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}

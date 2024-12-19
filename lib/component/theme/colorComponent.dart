import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:provider/provider.dart';

class ColorComponent {
  static Color mainColor = const Color(0xffFFCA0A);
  static Map<String, Color> gray = {
    "50": const Color(0xfff9fafb),
    "100": const Color(0xfff4f5f7),
    "200": const Color(0xffe5e7eb),
    "300": const Color(0xffd2d6dc),
    "400": const Color(0xff9fa6b2),
    "500": const Color(0xff6b7280),
    "600": const Color(0xff4b5563),
    "700": const Color(0xff374151),
    "800": const Color(0xff252f3f),
    "900": const Color(0xff161e2e),
  };
  static Map<String, Color> blue = {
    "50": const Color(0xffebf5ff),
    "100": const Color(0xffe1effe),
    "200": const Color(0xffc3ddfd),
    "300": const Color(0xffa4cafe),
    "400": const Color(0xff76a9fa),
    "500": const Color(0xff3f83f8),
    "600": const Color(0xff1c64f2),
    "700": const Color(0xff1a56db),
    "800": const Color(0xff1e429f),
    "900": const Color(0xff233876),
  };
  static Map<String, Color> red = {
    "50": const Color(0xfffdf2f2),
    "100": const Color(0xfffde8e8),
    "200": const Color(0xfffbd5d5),
    "300": const Color(0xfff8b4b4),
    "400": const Color(0xfff98080),
    "500": const Color(0xfff05252),
    "600": const Color(0xffe02424),
    "700": const Color(0xffc81e1e),
    "800": const Color(0xff9b1c1c),
    "900": const Color(0xff771d1d),
  };
}

class ThemeColorComponent {
  // ignore: non_constant_identifier_names
  static ColorsTheme(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool darkTheme = themeChange.darkTheme;
    return {
      'white_black': darkTheme ? Colors.black : Colors.white,
      'black_white': darkTheme ? Colors.white : Colors.black,
      'surring_grayWind':
          darkTheme ? const Color(0xff8D8D9D) : const Color(0xffF2F2F7),
      'gray_black': darkTheme ? const Color(0xffC7C7CC) : Colors.black,
      'dark_grayWind':
          darkTheme ? const Color(0xff8D8D9D) : const Color(0xff2C2C2E),
      'surring_dark':
          darkTheme ? const Color(0xff2C2C2E) : const Color(0xffF2F2F7),
      'white_surring': darkTheme ? Colors.white : const Color(0xffF2F2F7),
      'surring_black': darkTheme ? Colors.black : const Color(0xffF2F2F7),
      'orange_yellow':
          darkTheme ? const Color(0xffFFCC00) : const Color(0xffFF9500),
      'dark_graylike':
          darkTheme ? const Color(0xff2C2C2E) : const Color(0xffE5E5EA),
      'grayWind_graylike':
          darkTheme ? const Color(0xffE5E5EA) : const Color(0xff8D8D9D),
      'grayWind_white':
          darkTheme ? const Color(0xffE5E5EA) : const Color(0xff8D8D9D),
      'graylike_grayWind':
          darkTheme ? const Color(0xff8D8D9D) : const Color(0xffE5E5EA),
      'dark_white': darkTheme ? const Color(0xff2C2C2E) : Colors.white,
      'background': darkTheme ? const Color(0xff202022) : Colors.white,
      'darkPlace_grayLike':
          darkTheme ? const Color(0xffE5E5EA) : const Color(0xff56565E),
      'black_dark': darkTheme ? const Color(0xff2C2C2E) : Colors.black,
      'dark_black': darkTheme ? Colors.black : const Color(0xff2C2C2E),
      'grayShark_dark': darkTheme ? Colors.black : const Color(0xffD1D1D6),
      "brightness": darkTheme ? Brightness.dark : Brightness.light,
      "white_dark": darkTheme ? const Color(0xff2C2C2E) : Colors.white,
      'dark_transparent':
          darkTheme ? const Color(0xff2C2C2E) : Colors.transparent,
    };
  }
}

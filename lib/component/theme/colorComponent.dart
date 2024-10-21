import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:provider/provider.dart';

class ColorComponent {
  static Color mainColor = const Color(0xffFFCA0A);
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

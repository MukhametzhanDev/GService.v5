import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        // brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        dividerTheme: DividerThemeData(color: Colors.transparent),
        dialogTheme: DialogTheme(
            surfaceTintColor: isDarkTheme ? Colors.black : Colors.white),
        dialogBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
        textTheme: TextTheme(
          displayLarge:
              TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
          displayMedium:
              TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
          bodyMedium:
              TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
          titleMedium: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              overlayColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              padding: EdgeInsets.zero,
              foregroundColor: isDarkTheme ? Colors.white : Colors.black),
        ),
        primaryColor: isDarkTheme ? Colors.black : Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xffF9FAFB),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          errorStyle: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.red),
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: ColorComponent.gray['500']),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  width: 1,
                  color: isDarkTheme
                      ? const Color(0xffD1D5DB)
                      : const Color(0xffE5E5EA))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  width: 1,
                  color: isDarkTheme
                      ? const Color(0xffD1D5DB)
                      : const Color(0xffE5E5EA))),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(width: 2, color: ColorComponent.red)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  width: 1,
                  color: isDarkTheme
                      ? const Color(0xffD1D5DB)
                      : const Color(0xffE5E5EA))),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  width: 1,
                  color: isDarkTheme
                      ? const Color(0xffD1D5DB)
                      : const Color(0xffE5E5EA))),
          labelStyle: const TextStyle(color: Colors.red, fontSize: 24.0),
        ),
        indicatorColor:
            isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
        hintColor:
            isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
        highlightColor: Colors.transparent,
        hoverColor:
            isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
        focusColor:
            isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
        disabledColor: Colors.grey,
        unselectedWidgetColor: isDarkTheme ? Colors.white : Colors.black,
        cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
        canvasColor: isDarkTheme ? const Color(0xff202022) : Colors.grey[50],
        scaffoldBackgroundColor:
            isDarkTheme ? const Color(0xff202022) : Colors.white,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.light()),
        expansionTileTheme: ExpansionTileThemeData(
          collapsedTextColor: isDarkTheme ? Colors.white : Colors.black,
          textColor: isDarkTheme ? Colors.white : Colors.black,
        ),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.transparent))),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          surfaceTintColor: isDarkTheme ? Colors.black : Colors.white,
          systemOverlayStyle: isDarkTheme
              ? SystemUiOverlayStyle(
                  statusBarColor: Color(0xff202022),
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                )
              : SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
          titleTextStyle: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600),
          backgroundColor: isDarkTheme ? const Color(0xff202022) : Colors.white,
          elevation: 0.0,
          // ColorTheme['surring_dark']
          shape: Border(
              bottom: BorderSide(
                  color: isDarkTheme ? Colors.black : Colors.white, width: 1)),
          // ignore: deprecated_member_use
        ),
        listTileTheme: ListTileThemeData(
            titleTextStyle:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textColor: isDarkTheme ? Colors.white : Colors.black),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(
                background: isDarkTheme
                    ? const Color(0xff202022)
                    : const Color(0xffF1F5FB)),
        tabBarTheme: TabBarTheme(
          indicatorColor: ColorComponent.mainColor,
          labelColor: ColorComponent.mainColor,
          unselectedLabelColor: isDarkTheme ? Colors.white : Colors.black,
          labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDarkTheme ? Colors.white : Colors.black),
          unselectedLabelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDarkTheme ? Colors.white : Colors.black),
        ));
  }
}

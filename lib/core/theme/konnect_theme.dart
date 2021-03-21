import 'package:flutter/material.dart';

class KonnectTheme {
  //colors
  static const Color PRIMARY_COLOR = Color(0xFF1F997B);
  static const Color SECONDARY_COLOR = Color(0xFFFF8719);
  static const Color FONT_DARK_COLOR = Color(0xFF000000);
  static const Color FONT_LIGHT_COLOR = Color(0XFF4D4D4D);
  static const Color CARD_COLOR = Color(0xFFE7EEEC);
  static const Color SENDER_CARD_COLOR = Color(0xFFF5F5F6);
  static const Color RECEIVER_CARD_COLOR = Color(0xFFE5ECEB);
  static const Color ERROR_COLOR = Color(0xFFDA291C);

  static ThemeData konnectThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: PRIMARY_COLOR,
    accentColor: PRIMARY_COLOR,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w800,
        color: FONT_DARK_COLOR,
      ),
      headline2: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: FONT_DARK_COLOR,
      ),
      headline3: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: FONT_LIGHT_COLOR,
      ),
      headline4: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        color: FONT_DARK_COLOR,
      ),
      headline5: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: FONT_LIGHT_COLOR,
      ),
      headline6: TextStyle(
        fontSize: 9.0,
        fontWeight: FontWeight.w300,
        color: FONT_LIGHT_COLOR,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: SECONDARY_COLOR,
      disabledColor: SECONDARY_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeyapsakTheme {
  static TextTheme lightTextTheme = TextTheme(
    // genel düz yazılar
    bodyText1: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    // textfield yazıları için
    bodyText2: GoogleFonts.openSans(
      fontSize: 13.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    // büyük başlık
    headline1: GoogleFonts.openSans(
      letterSpacing: 3,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(252, 140, 106, 1),
    ),
    headline2: GoogleFonts.openSans(
      // büyük yazılar
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline4: GoogleFonts.openSans(
      // büyük yazıların başlığı
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline5: GoogleFonts.openSans(
      letterSpacing: 2,
      fontSize: 21.0,
      color: Color.fromRGBO(255, 187, 126, 1),
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    // button textleri
    button: GoogleFonts.openSans(
      fontSize: 10.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      primaryColor: Color.fromRGBO(255, 85, 33, 1),
      primaryColorLight: Color.fromRGBO(252, 140, 106, 1),
      backgroundColor: Color.fromRGBO(236, 239, 241, 1),
      cardColor: Color.fromRGBO(118, 143, 255, 1),
      brightness: Brightness.light,
      checkboxTheme:
          CheckboxThemeData(fillColor: MaterialStateColor.resolveWith((states) {
        return Colors.black;
      })),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      textButtonTheme: const TextButtonThemeData(),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.grey,
      ),
      // login kartının teması
      cardTheme: CardTheme(
        color:
            Color.fromRGBO(252, 140, 106, 1), // Color.fromRGBO(255, 87, 34, 1),
        shadowColor: Colors.black,
        elevation: 5,
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      // buttonların stili
      buttonTheme: ButtonThemeData(
        splashColor: Colors.white,
        //backgroundColor: Colors.pinkAccent,
        highlightColor: Colors.black,
        //elevation: 9.0,
        //highlightElevation: 6.0,
        //shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //shape: CircleBorder(side: BorderSide(color: Colors.green)),
        //shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      ),
      // input field stili
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade200, //Color.fromRGBO(255, 138, 80, 1),
        contentPadding: EdgeInsets.zero,
        errorStyle: const TextStyle(
          backgroundColor: Colors.orange,
          color: Colors.white,
        ),
        labelStyle: const TextStyle(fontSize: 12),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
          // borderRadius: inputBorder,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
          // borderRadius: inputBorder,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade700, width: 7),
          // borderRadius: inputBorder,
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade400, width: 8),
          // borderRadius: inputBorder,
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 5),
          // borderRadius: inputBorder,
        ),
      ),
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      textTheme: darkTextTheme,
    );
  }
}

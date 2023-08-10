import 'package:flutter/material.dart';

String fontStyle = 'Karla';
String fancyStyle = 'GreatVibes';

ThemeData createLightTheme(Color textColor, double width, double height) {
  final textScale = height * 0.01;
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: textScale * 11,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      headlineMedium: TextStyle(
        fontSize: textScale * 3.2,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      headlineSmall: TextStyle(
        fontSize: textScale * 3,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      titleLarge: TextStyle(
        fontSize: textScale * 3,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      titleMedium: TextStyle(
        fontSize: textScale * 2.5,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      titleSmall: TextStyle(
        fontSize: textScale * 2,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      bodyLarge: TextStyle(fontSize: textScale * 3, color: Colors.black),
      bodyMedium: TextStyle(
        fontSize: textScale * 2.5,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      bodySmall: TextStyle(
        fontSize: textScale * 2,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      displaySmall: TextStyle(
        fontSize: textScale * 2,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      displayMedium: TextStyle(
        fontSize: textScale * 2.5,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
      displayLarge: TextStyle(
        fontSize: textScale * 11,
        color: Colors.black,
        fontFamily: fontStyle,
      ),
    ),
    listTileTheme: const ListTileThemeData(tileColor: Colors.white),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.1),
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.1),
        foregroundColor: Colors.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: Colors.black, size: 36),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: textScale * 2.5,
        fontFamily: fontStyle,
      ),
      toolbarHeight: height * 1 / 15,
      backgroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0.0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.3)),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.blueAccent,
      selectionColor: Color.fromARGB(75, 68, 137, 255),
      selectionHandleColor: Colors.blue,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      labelStyle: TextStyle(
        color: Colors.black,
        fontFamily: fontStyle,
      ),
    ),
  );
}

ThemeData createDarkTheme(Color textColor, double width, double height) {
  final textScale = height * 0.01;
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: textScale * 11,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: fontStyle,
      ),
      headlineMedium: TextStyle(
        fontSize: textScale * 3.2,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: fontStyle,
      ),
      headlineSmall: TextStyle(
        fontSize: textScale * 3,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: fontStyle,
      ),
      titleLarge: TextStyle(
        fontSize: textScale * 3,
        color: Colors.white,
        fontFamily: fontStyle,
      ),
      titleMedium: TextStyle(
        fontSize: textScale * 2.5,
        color: Colors.white,
        fontFamily: fontStyle,
      ),
      titleSmall: TextStyle(
        fontSize: textScale * 2,
        color: Colors.white,
        fontFamily: fontStyle,
      ),
      bodyLarge: TextStyle(
        fontSize: textScale * 2.5,
        color: textColor,
        fontFamily: fontStyle,
      ),
      bodyMedium: TextStyle(
        fontSize: textScale * 2.5,
        color: textColor,
        fontFamily: fontStyle,
      ),
      bodySmall: TextStyle(
        fontSize: textScale * 2,
        color: Colors.white,
        fontFamily: fontStyle,
      ),
      displaySmall: TextStyle(
        fontSize: textScale * 2,
        color: Colors.white,
        fontFamily: fontStyle,
      ),
      displayMedium: TextStyle(
        fontSize: textScale * 2.5,
        color: Colors.white,
        fontFamily: fontStyle,
      ),
      displayLarge: TextStyle(
        fontSize: textScale * 11,
        color: Colors.white,
        fontFamily: fontStyle,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        foregroundColor: Colors.black,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: textColor,
          size: 36,
        ),
        titleTextStyle: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: textScale * 2.5,
          fontFamily: fontStyle,
        ),
        //backgroundColor: Colors.black,
        toolbarHeight: height * 1 / 15,
        backgroundColor: Colors.transparent),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      elevation: 0.0,
      //backgroundColor: selectedItem,
      selectedItemColor: textColor,
      unselectedItemColor: Colors.grey,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.blueAccent,
      selectionColor: Color.fromARGB(75, 68, 137, 255),
      selectionHandleColor: Colors.blue,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.white,
        fontFamily: fontStyle,
      ),
    ),
  );
}

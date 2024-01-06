import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = true;

  ThemeData getTheme() {
    return isDarkMode ? _darkTheme() : _lightTheme();
  }

  ThemeData _lightTheme() {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.blueAccent, // formerly known as accentColor
      ),
      textTheme: const TextTheme(
        titleSmall: TextStyle(fontSize: 14.0),
        titleMedium: TextStyle(fontSize: 16.0),
        titleLarge: TextStyle(fontSize: 18.0),
        bodyLarge: TextStyle(fontSize: 14.0),
        bodyMedium: TextStyle(fontSize: 18.0),
        bodySmall: TextStyle(fontSize: 20.0),
        labelLarge: TextStyle(fontSize: 14.0),
        labelMedium: TextStyle(fontSize: 16.0),
        labelSmall: TextStyle(fontSize: 18.0),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 13.0),
        hintStyle: TextStyle(fontSize: 13.0),
      ),
      // ... other properties
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      primaryColor: Colors.white30,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ).copyWith(
        secondary: Colors.blueGrey, // formerly known as accentColor
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 18.0),
        titleMedium: TextStyle(fontSize: 16.0),
        titleSmall: TextStyle(fontSize: 14.0),
        bodyLarge: TextStyle(fontSize: 18.0),
        bodyMedium: TextStyle(fontSize: 16.0),
        bodySmall: TextStyle(fontSize: 14.0),
        labelLarge: TextStyle(fontSize: 16.0),
        labelMedium: TextStyle(fontSize: 16.0),
        labelSmall: TextStyle(fontSize: 14.0),

      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 13.0),
        hintStyle: TextStyle(fontSize: 13.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          )
      ),
      // ... other properties
    );
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

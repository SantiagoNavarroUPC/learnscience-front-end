import 'package:flutter/material.dart';

const Color cursorColor = Color.fromARGB(255, 1, 79, 66);

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.teal,
  hintColor: cursorColor,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: cursorColor, // Configura el color del cursor
  ),

  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: cursorColor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: cursorColor),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: cursorColor),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: cursorColor),
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: cursorColor, // Configura el color del ícono de refresh
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    color: Colors.black, 
    selectedColor: cursorColor, 
    fillColor: cursorColor.withOpacity(0.1), 
    borderColor: Colors.black, 
    selectedBorderColor: cursorColor, 
    disabledColor: Colors.grey.shade400, 
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: cursorColor, // Color del texto del botón
    ),
  ),
);


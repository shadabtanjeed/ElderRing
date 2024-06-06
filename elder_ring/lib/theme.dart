import 'package:flutter/material.dart';

ThemeData Lightmode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey.shade300,
  secondaryHeaderColor: Colors.grey.shade200,
  fontFamily: 'Jost',
  colorScheme: const ColorScheme.light().copyWith(primary: Colors.blue, background: const Color(0xFFE5E5E5)), // Use the Jost font
);

ThemeData Darkmode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey.shade800,
  secondaryHeaderColor: Colors.grey.shade700,
  fontFamily: 'Jost',
  colorScheme: const ColorScheme.dark().copyWith(primary: Colors.blue, background: const Color(0xFF121212)), // Use the Jost font
);
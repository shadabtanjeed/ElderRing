import 'package:flutter/material.dart';

ThemeData Lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(),
  backgroundColor: const Color(0xFFE5E5E5),
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey.shade300,
  secondaryHeaderColor: Colors.grey.shade200,
  fontFamily: 'Jost', // Use the Jost font
);

ThemeData Darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(),
  backgroundColor: const Color(0xFF121212),
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey.shade800,
  secondaryHeaderColor: Colors.grey.shade700,
  fontFamily: 'Jost', // Use the Jost font
);

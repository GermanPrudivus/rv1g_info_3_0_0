import 'package:flutter/material.dart';

const background = Color.fromRGBO(255, 255, 255, 1);
const onBackground = Color.fromRGBO(43, 86, 147, 1);
const surface = Color.fromRGBO(172, 177, 193, 1);

const errorRed = Color.fromRGBO(245, 65, 53, 1);

Color blue = const Color.fromRGBO(43, 86, 147, 1);
Color shadowBlue = const Color.fromRGBO(43, 86, 147, 0.4);
Color lightGrey = const Color.fromRGBO(172, 177, 193, 1);
Color transparentLightGrey = const Color.fromRGBO(172, 177, 193, 0.70);

Color navigationBarColor = const Color.fromRGBO(241, 244, 251, 1);

Color appBarShadow = const Color.fromRGBO(43, 86, 147, 0.3);

const colorScheme = ColorScheme(
  primary: onBackground,
  onPrimary: background,
  secondary: surface,
  onSecondary: onBackground,
  background: background,
  onBackground: onBackground,
  surface: surface,
  onSurface: onBackground,
  error: errorRed,
  onError: errorRed,
  brightness: Brightness.light,
);
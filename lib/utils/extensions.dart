import 'package:flutter/material.dart';

// Context Extensions
extension usefulExtensions on BuildContext {
  Brightness get brightness => Theme.of(this).brightness;
  bool get isDark => this.brightness == Brightness.dark;

  TextTheme get texttheme => Theme.of(this).textTheme;
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get accentColor => Theme.of(this).accentColor;
}

// Color Tint
extension ColorTint on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
        this.alpha, (this.red * f).round(), (this.green * f).round(), (this.blue * f).round());
  }

  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(this.alpha, this.red + ((255 - this.red) * p).round(),
        this.green + ((255 - this.green) * p).round(), this.blue + ((255 - this.blue) * p).round());
  }
}

import 'package:flutter/material.dart';

extension GCE on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  bool get isDark => theme.brightness == Brightness.dark;
}

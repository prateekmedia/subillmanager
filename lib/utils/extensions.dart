import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:subillmanager/providers/providers.dart';

extension CacheM on int {
  get toCacheMode =>
      CacheMode.values.firstWhere((element) => element.index == this);
}

extension GenConExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  Color get primaryColor => theme.primaryColor;

  void pushPage(Widget page) => Navigator.push(
        this,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: page,
        ),
      );

  bool get isDark => theme.brightness == Brightness.dark;
}

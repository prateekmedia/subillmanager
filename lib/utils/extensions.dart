import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:subillmanager/providers/providers.dart';

const gsDateBase = 2209161600 / 86400;
const gsDateFactor = 86400000;

extension GetTextColorBasedOnBackground on Color {
  Color get getTextColor =>
      computeLuminance() > 0.45 ? Colors.black : Colors.white;
}

extension GetShortNameExtension on String {
  String get getShortName => (length > 0)
      ? trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
      : "S";

  String toDateFromSheet({bool localTime = true}) {
    final date = double.tryParse(this);
    if (date == null) return this;
    final millis = (date - gsDateBase) * gsDateFactor;
    return DateFormat("MMMM dd").format(
        DateTime.fromMillisecondsSinceEpoch(millis.round(), isUtc: localTime));
  }
}

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

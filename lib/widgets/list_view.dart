import 'package:flutter/material.dart';

ListView suListView({
  required List<Widget> children,
  EdgeInsets? padding,
  ScrollController? controller,
}) =>
    ListView(
      controller: controller,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 25),
      children: children,
    );

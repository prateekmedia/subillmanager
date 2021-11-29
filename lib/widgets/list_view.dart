import 'package:flutter/material.dart';

ListView suListView({
  required List<Widget> children,
  EdgeInsets? padding,
  ScrollController? controller,
  bool shrinkWrap = false,
}) =>
    ListView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 25),
      children: children,
    );

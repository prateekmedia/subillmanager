import 'package:flutter/material.dart';
import 'package:subillmanager/utils/constants.dart';

ListView suListView({
  required List<Widget> children,
  EdgeInsets? padding,
  ScrollController? controller,
  bool shrinkWrap = false,
}) =>
    ListView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding ?? listViewPadding,
      children: children,
    );

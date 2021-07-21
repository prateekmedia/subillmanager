import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

// ignore: non_constant_identifier_names
Widget AwesomePopCard(BuildContext context,
    {required List<Widget> headerChildren,
    MainAxisAlignment headerMainAxisAlignment = MainAxisAlignment.end,
    CrossAxisAlignment headerCrossAxisAlignment = CrossAxisAlignment.center,
    required List<Widget> footerChildren,
    double cardBorderRadius = 25,
    EdgeInsets footerPadding = const EdgeInsets.symmetric(horizontal: 15),
    bool centerWidget = true,
    String tag = "random"}) {
  if (Platform.isLinux) {
    headerChildren.addAll([
      MinimizeWindowButton(
        colors: WindowButtonColors(
            iconNormal: context.isDark ? Colors.white : Colors.black),
      ),
      MaximizeWindowButton(
        colors: WindowButtonColors(
            iconNormal: context.isDark ? Colors.white : Colors.black),
      ),
      CloseWindowButton(
        colors: WindowButtonColors(
          iconNormal: context.isDark ? Colors.white : Colors.black,
          mouseOver: Colors.red,
        ),
      )
    ]);
  }
  footerChildren.insert(
      0,
      const SizedBox(
        height: 15,
      ));
  var listView = ListView(
    padding: footerPadding,
    shrinkWrap: centerWidget,
    children:
        centerWidget ? [Column(children: footerChildren)] : footerChildren,
    physics: const BouncingScrollPhysics(),
  );
  return MoveWindow(
    child: Column(
      children: [
        Hero(
          tag: tag,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              color: primaryColor,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: headerMainAxisAlignment,
                  crossAxisAlignment: headerCrossAxisAlignment,
                  children: headerChildren,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: primaryColor,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(cardBorderRadius),
                    topLeft: Radius.circular(cardBorderRadius)),
                color: context.isDark ? Colors.grey[900]!.brighten(5) : grey,
              ),
              width: double.infinity,
              child: centerWidget ? Center(child: listView) : listView,
            ),
          ),
        ),
      ],
    ),
  );
}

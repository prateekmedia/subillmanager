import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

// ignore: non_constant_identifier_names
Widget AwesomePopCard(BuildContext context,
    {required List<Widget> headerChildren,
    MainAxisAlignment headerMainAxisAlignment = MainAxisAlignment.end,
    CrossAxisAlignment headerCrossAxisAlignment = CrossAxisAlignment.center,
    List<Widget>? footerChildren,
    Widget? footer,
    double cardBorderRadius = 25,
    EdgeInsets footerPadding = const EdgeInsets.symmetric(horizontal: 15),
    bool centerWidget = true,
    String tag = "random"}) {
  if (Platform.isLinux) {
    headerChildren.addAll([
      MinimizeWindowButton(
        colors: WindowButtonColors(iconNormal: Colors.white),
      ),
      MaximizeWindowButton(
        colors: WindowButtonColors(iconNormal: Colors.white),
      ),
      CloseWindowButton(
        colors: WindowButtonColors(
          iconNormal: Colors.white,
          mouseOver: Colors.red,
        ),
      )
    ]);
  }
  if (footerChildren != null) {
    footerChildren.insert(
        0,
        const SizedBox(
          height: 15,
        ));
  }
  var listView = footerChildren != null
      ? ListView(
          padding: footerPadding,
          shrinkWrap: centerWidget,
          children: centerWidget
              ? [Column(children: footerChildren)]
              : footerChildren,
          physics: const BouncingScrollPhysics(),
        )
      : const SizedBox();
  return Column(
    children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          appWindow.startDragging();
        },
        onDoubleTap: () => appWindow.maximizeOrRestore(),
        child: Hero(
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
            child:
                footer ?? (centerWidget ? Center(child: listView) : listView),
          ),
        ),
      ),
    ],
  );
}

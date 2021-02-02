import 'package:flutter/material.dart';

import '../utils.dart';

// ignore: non_constant_identifier_names
Widget AwesomePopCard(BuildContext context,
    {List<Widget> headerChildren,
    List<Widget> footerChildren,
    double cardBorderRadius = 25,
    EdgeInsets footerPadding = const EdgeInsets.symmetric(horizontal: 15)}) {
  return Column(
    children: [
      Container(
        color: primaryColor,
        padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: headerChildren,
        ),
      ),
      Expanded(
        child: Stack(
          children: [
            Container(
              height: 30,
              color: primaryColor,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(cardBorderRadius),
                    topLeft: Radius.circular(cardBorderRadius)),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.brighten(30).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                color: context.isDark ? Colors.grey[900].brighten(5) : grey,
              ),
              padding: footerPadding,
              width: double.infinity,
              child: ListView(
                children: footerChildren,
                physics: BouncingScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

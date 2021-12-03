import 'package:flutter/material.dart';
import 'package:subillmanager/utils/utils.dart';

Widget profileIcon(BuildContext context,
    {required String name,
    required Color bgColor,
    required double size,
    required TextStyle headlinetype,
    Color shadowColor = Colors.black}) {
  return Material(
    borderRadius: BorderRadius.circular(100),
    color: bgColor,
    child: SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          name.getShortName,
          style: headlinetype.copyWith(
              color: bgColor.getTextColor, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

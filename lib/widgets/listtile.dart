import 'package:flutter/material.dart';

import '../utils/utils.dart';

// ignore: non_constant_identifier_names
Widget AwesomeListTile(
  BuildContext context, {
  IconData? icon,
  String? title,
  String? subtitle,
  String? trailing,
  bool visible = true,
}) {
  return visible
      ? ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          tileColor: context.isDark ? Colors.grey[900] : Colors.white,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.isDark ? const Color(0xFF4F4F4F) : const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  icon,
                  color: context.isDark ? primaryColor.brighten(70) : primaryColor,
                ),
              ),
            ],
          ),
          title: Text(
            title!,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: context.isDark ? primaryColor.brighten(75) : primaryColor),
          ),
          subtitle: Text(
            subtitle!,
            style: TextStyle(color: context.isDark ? primaryColor.brighten(75) : primaryColor),
          ),
          trailing: Text(
            trailing!,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.isDark ? primaryColor.brighten(75) : primaryColor,
                fontSize: 18),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        )
      : Container();
}

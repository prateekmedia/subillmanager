import 'package:flutter/material.dart';

import '../utils.dart';

// ignore: non_constant_identifier_names
ListTile AwesomeListTile(BuildContext context,
    {IconData icon, String title, String subtitle, String trailing}) {
  return ListTile(
    tileColor: Colors.white,
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            icon,
            color: primaryColor,
          ),
        ),
      ],
    ),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(color: primaryColor),
    ),
    trailing: Text(
      trailing,
      style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor, fontSize: 18),
    ),
    contentPadding: EdgeInsets.all(10),
  );
}

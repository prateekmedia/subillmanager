import 'package:flutter/material.dart';

import '../utils.dart';

// ignore: non_constant_identifier_names
Widget AwesomeListTile(BuildContext context,
    {IconData icon,
    String title,
    String subtitle,
    String trailing,
    Offset offset = const Offset(0, 2)}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: context.isDark ? Colors.black38 : Colors.grey[200].withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 8,
          offset: offset,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        tileColor: context.isDark ? Colors.grey[900] : Colors.white,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.isDark ? Color(0xFF4F4F4F) : Color(0xFFF4F4F4),
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
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: context.isDark ? primaryColor.brighten(40) : primaryColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: context.isDark ? primaryColor.brighten(40) : primaryColor),
        ),
        trailing: Text(
          trailing,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: context.isDark ? primaryColor.brighten(40) : primaryColor,
              fontSize: 18),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    ),
  );
}

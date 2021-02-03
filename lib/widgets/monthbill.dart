import 'package:flutter/material.dart';
import '../utils.dart';

// ignore: non_constant_identifier_names
Widget AwesomeMonthBill(BuildContext context, {String title, List<Widget> children}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Text(
          title,
          style:
              TextStyle(fontSize: 16, color: context.isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
      ),
      Container(
        child: Column(children: children),
      ),
    ],
  );
}

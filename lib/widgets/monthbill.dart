import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget AwesomeMonthBill(BuildContext context, {String title, List<Widget> children}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
      Container(
        child: Column(children: children),
      ),
    ],
  );
}

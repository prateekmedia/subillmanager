import 'package:flutter/material.dart';
import '../utils.dart';

// ignore: non_constant_identifier_names
Widget AwesomeMonthBill(BuildContext context,
    {String? title, Widget? trailing, List<Widget>? children, bool visible = true}) {
  return visible
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                        fontSize: 16, color: context.isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  trailing ?? Container(),
                ],
              ),
            ),
            Container(
              child: Column(children: children!),
            ),
          ],
        )
      : Container();
}

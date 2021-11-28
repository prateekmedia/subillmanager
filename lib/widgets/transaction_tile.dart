import 'package:flutter/material.dart';
import 'package:subillmanager/utils/utils.dart';

class TransactionTile extends StatelessWidget {
  final String name;
  final String date;
  final double price;

  const TransactionTile({
    Key? key,
    required this.name,
    required this.date,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[context.isDark ? 800 : 200],
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const FlutterLogo(size: 35),
        minLeadingWidth: 10,
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(date),
        trailing: Text(
          "₹ $price",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[context.isDark ? 200 : 600],
          ),
        ),
      ),
    );
  }
}

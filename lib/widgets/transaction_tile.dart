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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          const FlutterLogo(size: 35),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(date),
              ],
            ),
          ),
          Text(
            "₹ $price",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[context.isDark ? 200 : 600],
            ),
          ),
        ],
      ),
    );
  }
}

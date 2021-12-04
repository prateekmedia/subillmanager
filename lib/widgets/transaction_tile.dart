import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/providers/providers.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/profile_icon.dart';

class TransactionTile extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[context.isDark ? 800 : 200],
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: profileIcon(
          context,
          name: name,
          bgColor: Colors.blue,
          size: 35,
          headlinetype: const TextStyle(),
        ),
        minLeadingWidth: 10,
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(date.toDateFromSheet()),
        trailing: Text(
          "${ref.watch(currencyProvider.notifier).currency} ${price.toStringAsFixed(1)}",
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

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';

class TransactionsTab extends ConsumerWidget {
  final AsyncSnapshot snapshot;
  final Function refreshData;

  const TransactionsTab({
    Key? key,
    required this.snapshot,
    required this.refreshData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: listViewPadding,
      itemBuilder: (ctx, idx) => const TransactionTile(
        name: "Random Person",
        date: "November 1",
        price: 8.12,
      ),
      itemCount: 15,
    );
  }
}

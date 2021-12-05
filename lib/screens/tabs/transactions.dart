import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/providers/providers.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';

class TransactionsTab extends ConsumerWidget {
  final AsyncSnapshot<List> snapshot;
  final Function refreshData;

  const TransactionsTab({
    Key? key,
    required this.snapshot,
    required this.refreshData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(cacheModeProvider).index == 0
        ? ListView.builder(
            controller: ScrollController(),
            padding: listViewPadding,
            itemBuilder: (ctx, idx) => const TransactionTile(
              name: "Random Person",
              date: "November 1",
              price: 8.12,
            ),
            itemCount: 15,
          )
        : RefreshIndicator(
            onRefresh: ref.watch(cacheModeProvider).index == 2
                ? () => refreshData()
                : () async {},
            child: suListView(children: [
              if (snapshot.hasData && snapshot.data != null)
                if (snapshot.data!.isNotEmpty)
                  ...transactionsList(ref, snapshot)
                else
                  const Text("No data found")
              else
                const LinearProgressIndicator(),
            ]),
          );
  }
}

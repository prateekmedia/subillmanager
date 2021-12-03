import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/providers/providers.dart';
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
        : suListView(children: [
            if (snapshot.hasData && snapshot.data != null)
              if (snapshot.data!.isNotEmpty)
                ...List.generate(
                  (snapshot.data![0] as List).length - 1,
                  (index) {
                    int itemIndex = snapshot.data![0].length - 1 - index;
                    return Column(
                      children: List.generate(
                        snapshot.data!.length - 1,
                        (nameIndex) => TransactionTile(
                          name: snapshot.data![nameIndex + 1][0],
                          date: snapshot.data![0][itemIndex],
                          price: (double.parse(snapshot.data![nameIndex + 1]
                                      [itemIndex]) -
                                  ((itemIndex == 1)
                                      ? 0
                                      : double.parse(
                                          snapshot.data![nameIndex + 1]
                                              [itemIndex - 1]))) *
                              ref.watch(unitCostProvider),
                        ),
                      ),
                    );
                  },
                )
              else
                const Text("No data found")
            else
              const LinearProgressIndicator(),
          ]);
  }
}

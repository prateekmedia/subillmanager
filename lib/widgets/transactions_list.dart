import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:subillmanager/widgets/widgets.dart';
import 'package:subillmanager/providers/providers.dart';

List<Widget> transactionsList(WidgetRef ref, AsyncSnapshot<List> snapshot,
    [bool isOnHome = false]) {
  return List.generate(
    (snapshot.data![0] as List).sublist(0, isOnHome ? 4 : null).length - 1,
    (index) {
      int itemIndex = snapshot.data![0].length - 1 - index;
      return Column(
        children: List.generate(
          snapshot.data!.length - 1,
          (nameIndex) => TransactionTile(
            name: snapshot.data![nameIndex + 1][0],
            date: snapshot.data![0][itemIndex],
            price: (double.parse(snapshot.data![nameIndex + 1][itemIndex]) -
                    ((itemIndex == 1)
                        ? 0
                        : double.parse(
                            snapshot.data![nameIndex + 1][itemIndex - 1]))) *
                ref.watch(unitCostProvider),
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/providers/providers.dart';
import 'package:subillmanager/screens/tabs/home/add.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';

class HomeTab extends ConsumerWidget {
  final AsyncSnapshot<List> snapshot;

  const HomeTab({
    Key? key,
    required this.goToTab,
    required this.snapshot,
  }) : super(key: key);

  final Function(int t) goToTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return suListView(
      controller: ScrollController(),
      children: <Widget>[
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[700],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Monthly balance",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ref.watch(currencyProvider.notifier).currency +
                        " " +
                        (ref.watch(cacheModeProvider) == CacheMode.dummy
                            ? "1500"
                            : snapshot.data == null
                                ? "0"
                                : ref.watch(cacheModeProvider) ==
                                        CacheMode.cache
                                    ? "0"
                                    : (double.parse(snapshot.data![1][2]) +
                                            double.parse(snapshot.data![2][2]))
                                        .toString()),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.pushPage(const AddEntry()),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.isDark ? Colors.black45 : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.add,
                    color: context.isDark ? Colors.white70 : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent transactions",
              style: TextStyle(fontSize: 18),
            ),
            TextButton(
              onPressed: () => goToTab(1),
              child: const Text("See all"),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (ref.watch(cacheModeProvider) == CacheMode.dummy) ...const [
          TransactionTile(
            name: "Person 1",
            date: "March 1",
            price: 8.9,
          ),
          TransactionTile(
            name: "Person 2",
            date: "March 1",
            price: 8.9,
          ),
          TransactionTile(
            name: "Person 1",
            date: "February 1",
            price: 8.9,
          ),
          TransactionTile(
            name: "Person 2",
            date: "February 1",
            price: 8.9,
          ),
          TransactionTile(
            name: "Person 2",
            date: "March 1",
            price: 8.9,
          ),
        ] else if (snapshot.hasData && snapshot.data != null)
          if (snapshot.data!.isNotEmpty)
            ...List.generate(
              snapshot.data![0].length - 1,
              (index) {
                int itemIndex = snapshot.data![0].length - 1 - index;
                return Column(
                  children: List.generate(
                    snapshot.data!.length - 1,
                    (nameIndex) => TransactionTile(
                      name: snapshot.data![nameIndex + 1][0],
                      date: snapshot.data![0][itemIndex],
                      price: (double.parse(
                                  snapshot.data![nameIndex + 1][itemIndex]) -
                              ((itemIndex == 1)
                                  ? 0
                                  : double.parse(snapshot.data![nameIndex + 1]
                                      [itemIndex - 1]))) *
                          ref.watch(unitCostProvider),
                    ),
                  ),
                );
              },
            )
          else
            const Text("No cache data found")
        else
          const LinearProgressIndicator(),
      ],
    );
  }
}

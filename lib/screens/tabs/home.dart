import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/providers/providers.dart';
import 'package:subillmanager/screens/tabs/home/add.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({
    Key? key,
    required this.goToTab,
  }) : super(key: key);

  final Function(int t) goToTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return suListView(
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
                    "${ref.watch(currencyProvider.notifier).currency} 1500",
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
        const TransactionTile(
          name: "Person 1",
          date: "March 1",
          price: 8.9,
        ),
        const TransactionTile(
          name: "Person 2",
          date: "March 1",
          price: 8.9,
        ),
        const TransactionTile(
          name: "Person 1",
          date: "February 1",
          price: 8.9,
        ),
        const TransactionTile(
          name: "Person 2",
          date: "February 1",
          price: 8.9,
        ),
        const TransactionTile(
          name: "Person 2",
          date: "March 1",
          price: 8.9,
        ),
      ],
    );
  }
}

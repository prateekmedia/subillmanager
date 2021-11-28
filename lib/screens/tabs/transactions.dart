import 'package:flutter/material.dart';
import 'package:subillmanager/widgets/widgets.dart';

class TransactionsTab extends StatelessWidget {
  const TransactionsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return suListView(
      children: <Widget>[
        const Text("Transactions"),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  Text(
                    "Monthly balance",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "₹ 1500",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  debugPrint("Add");
                },
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
        const Text(
          "Recent transactions",
          style: TextStyle(fontSize: 18),
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
      ],
    );
  }
}

import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:subillmanager/widgets/appbar.dart';
import 'package:subillmanager/widgets/list_view.dart';

class AddEntry extends StatelessWidget {
  const AddEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateController = TextEditingController(
      text: DateFormat('MMMM dd').format(DateTime.now()),
    );
    final person1Controller = TextEditingController();
    final person2Controller = TextEditingController();

    return Scaffold(
      appBar: suAppBar(
        context,
        title: "Add",
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(LucideIcons.check),
          ),
        ],
      ),
      body: suListView(children: [
        const SizedBox(height: 8),
        TextField(
          controller: dateController,
          decoration: InputDecoration(
            labelText: "Date",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: person1Controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Person 1 Unit",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: person2Controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Person 2 Unit",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
      ]),
    );
  }
}

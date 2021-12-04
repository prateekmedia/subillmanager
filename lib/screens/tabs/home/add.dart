import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gsheets/gsheets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:subillmanager/providers/cache_mode_provider.dart';
import 'package:subillmanager/widgets/appbar.dart';
import 'package:subillmanager/widgets/list_view.dart';

class AddEntry extends HookConsumerWidget {
  final Worksheet? worksheet;
  final AsyncSnapshot<List> snapshot;

  const AddEntry({
    Key? key,
    required this.snapshot,
    required this.worksheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateController = useTextEditingController(
      text: DateFormat('MMMM dd').format(DateTime.now()),
    );
    final person1Controller = useTextEditingController();
    final person2Controller = useTextEditingController();
    final isLoading = useState(false);

    return Scaffold(
      appBar: suAppBar(
        context,
        title: "Add",
        actions: [
          IconButton(
            onPressed: () async {
              isLoading.value = true;
              if (ref.read(cacheModeProvider).index == 2) {
                var cell1 = await worksheet!.cells
                    .cell(row: snapshot.data![0].length + 1, column: 1);
                var cell2 = await worksheet!.cells
                    .cell(row: snapshot.data![0].length + 1, column: 2);
                var cell3 = await worksheet!.cells
                    .cell(row: snapshot.data![0].length + 1, column: 3);
                await cell1.post(dateController.text.trim());
                await cell2.post(person1Controller.text.trim());
                await cell3.post(person2Controller.text.trim());
              }
              isLoading.value = false;
              BotToast.showText(text: "Successfully added!");
              Navigator.of(context).pop();
            },
            icon: isLoading.value
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator())
                : const Icon(LucideIcons.check),
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

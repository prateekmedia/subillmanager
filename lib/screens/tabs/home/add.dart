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

    final isItOk =
        ref.watch(cacheModeProvider).index == 2 && snapshot.data != null;

    int listLength = isItOk ? snapshot.data!.length - 1 : 2;

    List<TextEditingController> personsController = List.generate(
      listLength,
      (index) => useTextEditingController(),
    );
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
                await cell1.post(dateController.text.trim());
                for (var index = 0; index < listLength; index++) {
                  var cell = await worksheet!.cells.cell(
                      row: snapshot.data![0].length + 1, column: index + 2);
                  await cell.post(personsController[index].text.trim());
                }
              }
              isLoading.value = false;
              BotToast.showText(
                text: isItOk ? "Successfully added!" : "Demo Complete!",
              );
              Navigator.of(context).pop();
            },
            icon: isLoading.value
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator())
                : const Icon(LucideIcons.check),
          ),
        ],
      ),
      body: suListView(
        children: [
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
          ...List.generate(
            listLength,
            (index) => Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: TextField(
                controller: personsController[index],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: (isItOk
                          ? snapshot.data![index + 1][0]
                          : "Person ${index + 1}") +
                      " Unit",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

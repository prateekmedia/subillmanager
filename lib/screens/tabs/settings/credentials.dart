import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:subillmanager/providers/providers.dart';
import 'package:subillmanager/widgets/widgets.dart';

class CredentialsSettings extends ConsumerWidget {
  const CredentialsSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _clientIdController =
        TextEditingController(text: ref.read(credentialsProvider).clientId);
    final _spreadsheetIdController = TextEditingController(
        text: ref.read(credentialsProvider).spreadsheetId);

    return Scaffold(
      appBar: suAppBar(
        context,
        title: "Credentials",
        actions: [
          IconButton(
            onPressed: () {
              ref.read(credentialsProvider).clientId = _clientIdController.text;
              ref.read(credentialsProvider).spreadsheetId =
                  _spreadsheetIdController.text;
              Navigator.of(context).pop();
            },
            icon: const Icon(LucideIcons.check),
          ),
        ],
      ),
      body: suListView(
        children: [
          TextField(
            controller: _spreadsheetIdController,
            decoration: InputDecoration(
              labelText: "Enter Spreadsheet ID",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: null,
            controller: _clientIdController,
            decoration: InputDecoration(
              labelText: "Enter Google Client ID",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:subillmanager/providers/providers.dart';
import 'package:subillmanager/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

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
            tooltip: "Help",
            onPressed: () =>
                launch('https://github.com/prateekmedia/subillmanager/wiki'),
            icon: const Icon(LucideIcons.helpCircle),
          ),
          IconButton(
            tooltip: "Submit",
            onPressed: () {
              ref.read(credentialsProvider).clientId = _clientIdController.text;
              ref.read(credentialsProvider).spreadsheetId =
                  _spreadsheetIdController.text;

              if (ref.read(cacheModeProvider).index != 2) {
                ref.read(cacheModeProvider.notifier).value = 2;
              }
              Navigator.of(context).pop();
            },
            icon: const Icon(LucideIcons.check),
          ),
        ],
      ),
      body: suListView(
        children: [
          const SizedBox(height: 8),
          TextField(
            controller: _spreadsheetIdController,
            decoration: InputDecoration(
              labelText: "Spreadsheet ID",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: null,
            controller: _clientIdController,
            decoration: InputDecoration(
              labelText: "Google Client ID",
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

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:subillmanager/widgets/widgets.dart';

class CredentialsSettings extends ConsumerWidget {
  const CredentialsSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: suAppBar(
        context,
        title: "Credentials",
        actions: [
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(LucideIcons.check),
          ),
        ],
      ),
      body: suListView(
        children: [
          TextField(
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

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/widgets/widgets.dart';

class CredentialsSettings extends ConsumerWidget {
  const CredentialsSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: suAppBar(
        context,
        title: "Credentials",
      ),
      body: suListView(
        children: [],
      ),
    );
  }
}

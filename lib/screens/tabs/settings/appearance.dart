import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';
import 'package:subillmanager/providers/providers.dart';

class AppearanceSettings extends ConsumerWidget {
  const AppearanceSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void changeTheme(bool val) =>
        ref.read(themeTypeProvider.notifier).themeType = val ? 2 : 1;

    return Scaffold(
      appBar: suAppBar(
        context,
        title: "Appearance",
      ),
      body: suListView(
        children: [
          SettingTile.advanced(
            title: "Dark Mode",
            icon: Icons.nightlight_round,
            onPressed: () => changeTheme(!context.isDark),
            trailing: Switch(
              value: context.isDark,
              onChanged: changeTheme,
            ),
          ),
        ],
      ),
    );
  }
}

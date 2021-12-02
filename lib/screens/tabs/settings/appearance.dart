import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';
import 'package:subillmanager/providers/providers.dart';

class AppearanceSettings extends ConsumerWidget {
  const AppearanceSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perUnitCostController =
        TextEditingController(text: ref.watch(unitCostProvider).toString());
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
          SettingTile.advanced(
            title: "Currency",
            icon: LucideIcons.currency,
            trailing: DropdownButton<int>(
                value: ref.watch(currencyProvider),
                items: List.generate(
                  currencies.length,
                  (index) => DropdownMenuItem(
                    child:
                        Text("${currencyName[index]} (${currencies[index]})"),
                    value: index,
                  ),
                ),
                onChanged: (val) =>
                    ref.read(currencyProvider.notifier).value = val ?? 0),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: perUnitCostController,
            onChanged: (value) =>
                ref.read(unitCostProvider.notifier).value = double.parse(value),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Per Unit Cost",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          )
        ],
      ),
    );
  }
}

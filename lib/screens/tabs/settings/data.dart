import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';

class DataSettings extends ConsumerWidget {
  const DataSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: suAppBar(
        context,
        title: "Data",
      ),
      body: suListView(
        children: [
          SettingTile.advanced(
            title: "Cache Mode",
            icon: Icons.sd_card,
            onPressed: () {},
            trailing: Switch(
              value: context.isDark,
              onChanged: (val) {},
            ),
          ),
          const SettingTile.advanced(
              title: "Clear Data", icon: Icons.dashboard_outlined),
        ],
      ),
    );
  }
}

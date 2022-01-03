import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/providers/providers.dart';
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
            trailing: DropdownButton<int>(
              value: ref.watch(cacheModeProvider).index,
              items: List.generate(
                CacheMode.values.length,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(
                    describeEnum(
                      CacheMode.values
                          .firstWhere((element) => element.index == index),
                    ),
                  ),
                ),
              ),
              onChanged: (val) =>
                  ref.read(cacheModeProvider.notifier).value = val ?? 0,
            ),
          ),
          SettingTile.advanced(
            title: "Clear Data",
            icon: Icons.dashboard_outlined,
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Are you Sure?"),
                content: const Text("This will reset all of you data."),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: context.isDark
                          ? Colors.grey[200]!
                          : context.primaryColor,
                    ),
                    child: const Text("CANCEL"),
                    onPressed: Navigator.of(context).pop,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: context.textTheme.bodyText2!.color),
                    child: const Text("YES"),
                    onPressed: () {
                      ref.resetAllProviders();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

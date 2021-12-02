import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:subillmanager/screens/tabs/settings/about.dart';
import 'package:subillmanager/screens/tabs/settings/appearance.dart';
import 'package:subillmanager/screens/tabs/settings/credentials.dart';
import 'package:subillmanager/screens/tabs/settings/data.dart';
import 'package:subillmanager/widgets/widgets.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return suListView(
      controller: ScrollController(),
      children: const [
        SettingTile(
          title: "Appearance",
          icon: Icons.nightlight,
          goToPage: AppearanceSettings(),
        ),
        SettingTile(
          title: "Credentials",
          icon: Icons.password,
          goToPage: CredentialsSettings(),
        ),
        SettingTile(
          title: "Data",
          icon: Icons.data_usage,
          goToPage: DataSettings(),
        ),
        SettingTile(
          title: "About",
          icon: LucideIcons.info,
          goToPage: AboutSettings(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subillmanager/utils/utils.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? goToPage;
  final VoidCallback? onPressed;
  final Widget? trailing;

  const SettingTile({
    Key? key,
    required this.title,
    required this.icon,
    this.goToPage,
  })  : onPressed = null,
        trailing = const Icon(Icons.chevron_right),
        super(key: key);

  const SettingTile.advanced({
    Key? key,
    required this.title,
    required this.icon,
    this.onPressed,
    this.trailing,
  })  : goToPage = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: ListTile(
          minLeadingWidth: 0,
          tileColor: Colors.grey[context.isDark ? 800 : 300],
          leading: Icon(icon),
          onTap:
              goToPage != null ? () => context.pushPage(goToPage!) : onPressed,
          shape: const StadiumBorder(),
          title: Text(title),
          trailing: trailing,
        ),
      ),
    );
  }
}

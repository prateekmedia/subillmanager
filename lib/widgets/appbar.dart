import 'package:flutter/material.dart';
import 'package:subillmanager/utils/utils.dart';

AppBar suAppBar(
  BuildContext context, {
  required String title,
  bool automaticallyImplyLeading = true,
  Widget? leading,
}) {
  return AppBar(
    title: Text(title),
    iconTheme: context.theme.iconTheme,
    leading:
        automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false)
            ? IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.chevron_left),
              )
            : leading,
    elevation: 0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    titleTextStyle: context.textTheme.headline6,
  );
}

import 'package:flutter/material.dart';
import 'package:subillmanager/widgets/appbar.dart';
import 'package:subillmanager/widgets/list_view.dart';

class AddEntry extends StatelessWidget {
  const AddEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: suAppBar(context, title: "Add"),
      body: suListView(children: []),
    );
  }
}

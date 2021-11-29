import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/widgets/widgets.dart';

class AboutSettings extends ConsumerWidget {
  const AboutSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: suAppBar(
        context,
        title: "About",
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) => Center(
          child: suListView(
            shrinkWrap: true,
            children: [
              Image.asset(
                "assets/subillmanager.png",
                height: 128,
                width: 128,
              ),
              const Center(
                child: Text(
                  appName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "v" +
                      (snapshot.data != null
                          ? snapshot.data!.buildNumber
                          : "1.0.0"),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => showLicensePage(context: context),
                    child: const Text("Licenses"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:subillmanager/utils/utils.dart';
import 'package:subillmanager/screens/screens.dart';
import 'package:subillmanager/widgets/widgets.dart';
import 'package:subillmanager/providers/providers.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _controller = usePageController();
    final _currentPage = useState<int>(0);
    final titles = ["Home", "Transactions", "Settings"];
    final sheet = useState<Worksheet?>(null);
    List demoM = Hive.box('cache').get('value', defaultValue: []);
    const Map<String, IconData> items = {
      "Home": LucideIcons.home,
      "Transactions": LucideIcons.wallet,
      "Settings": LucideIcons.settings2,
    };

    void goToTab(int tab) => _controller.animateToPage(
          tab,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastLinearToSlowEaseIn,
        );

    Future<List<List<String>>> initSheet() async {
      var clientId = ref.read(credentialsProvider).clientId;
      var spreadsheetId = ref.read(credentialsProvider).spreadsheetId;
      if (clientId.trim().isNotEmpty) {
        var gsheets = GSheets(clientId);
        sheet.value =
            (await gsheets.spreadsheet(spreadsheetId)).worksheetByIndex(0);
        return sheet.value!.values.allColumns();
      }
      return [];
    }

    final _getTaskAsync = useState(useMemoized(() => initSheet()));

    return Scaffold(
      appBar: suAppBar(
        context,
        title: titles[_currentPage.value],
        actions: [
          if (_currentPage.value == 1 &&
              ref.watch(cacheModeProvider).index == 2)
            IconButton(
              onPressed: () => _getTaskAsync.value = initSheet(),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: FutureBuilder<List>(
          future: ref.watch(cacheModeProvider).index == 1
              ? Future.value(demoM)
              : _getTaskAsync.value,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                ref.watch(cacheModeProvider).index == 2) {
              Hive.box('cache').put('value', snapshot.data);
            }
            return Row(
              children: [
                if (!context.isMobile)
                  NavigationRail(
                    backgroundColor: Colors.transparent,
                    labelType: NavigationRailLabelType.selected,
                    destinations: List.generate(
                      items.entries.length,
                      (index) => NavigationRailDestination(
                        icon: Icon(items.values.toList()[index]),
                        label: Text(items.keys.toList()[index]),
                      ),
                    ),
                    onDestinationSelected: (tab) => goToTab(tab),
                    selectedIndex: _currentPage.value,
                  ),
                Expanded(
                  child: PageView(
                    physics: context.isMobile
                        ? null
                        : const NeverScrollableScrollPhysics(),
                    scrollDirection:
                        context.isMobile ? Axis.horizontal : Axis.vertical,
                    controller: _controller,
                    onPageChanged: (page) => _currentPage.value = page,
                    children: [
                      HomeTab(
                        goToTab: goToTab,
                        snapshot: snapshot,
                        worksheet: sheet.value,
                      ),
                      TransactionsTab(
                        snapshot: snapshot,
                        refreshData: () => _getTaskAsync.value = initSheet(),
                      ),
                      const SettingsTab(),
                    ],
                  ),
                ),
              ],
            );
          }),
      bottomNavigationBar: context.isMobile
          ? BottomNavigationBar(
              currentIndex: _currentPage.value,
              landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
              onTap: (tab) => goToTab(tab),
              items: List.generate(
                items.entries.length,
                (index) => BottomNavigationBarItem(
                  icon: Icon(items.values.toList()[index]),
                  label: items.keys.toList()[index],
                ),
              ),
            )
          : null,
    );
  }
}

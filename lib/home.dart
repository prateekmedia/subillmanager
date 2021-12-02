import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gsheets/gsheets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:subillmanager/screens/screens.dart';
import 'package:subillmanager/widgets/widgets.dart';
import 'package:subillmanager/providers/providers.dart';

class Home extends StatefulHookWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _controller = PageController();
    final _currentPage = useState<int>(0);
    final titles = ["Home", "Transactions", "Settings"];
    late Spreadsheet ss;
    final sheet = useState<Worksheet?>(null);
    List demoM = Hive.box('DEMO').get('demo', defaultValue: []);

    void goToTab(int tab) => _controller.animateToPage(
          tab,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastLinearToSlowEaseIn,
        );

    return Consumer(builder: (context, ref, _) {
      Future<List<List<String>>> initSheet() async {
        var clientId = ref.read(credentialsProvider).clientId;
        var spreadsheetId = ref.read(credentialsProvider).spreadsheetId;
        if (clientId.trim().isNotEmpty) {
          var gsheets = GSheets(clientId);

          // fetch spreadsheet by its id
          ss = await gsheets.spreadsheet(spreadsheetId);
          // get worksheet by its index
          sheet.value = ss.worksheetByIndex(0);
          return sheet.value!.values.allColumns();
        }
        return [];
      }

      final _getTaskAsync = useState(useMemoized(() => initSheet()));

      return Scaffold(
        appBar: suAppBar(
          context,
          title: titles[_currentPage.value],
        ),
        body: FutureBuilder<List>(
            future: ref.watch(cacheModeProvider).index > 1
                ? Future.value(demoM)
                : _getTaskAsync.value,
            builder: (context, snapshot) {
              return PageView(
                controller: _controller,
                onPageChanged: (page) => _currentPage.value = page,
                children: [
                  HomeTab(goToTab: goToTab, snapshot: snapshot),
                  TransactionsTab(
                    snapshot: snapshot,
                    refreshData: () => _getTaskAsync.value = initSheet(),
                  ),
                  const SettingsTab(),
                ],
              );
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage.value,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          onTap: (tab) => goToTab(tab),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.wallet),
              label: "Transactions",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.settings2),
              label: "Settings",
            ),
          ],
        ),
      );
    });
  }
}

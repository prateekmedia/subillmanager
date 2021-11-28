import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:subillmanager/screens/screens.dart';
import 'package:subillmanager/widgets/widgets.dart';

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

    void goToTab(int tab) => _controller.animateToPage(
          tab,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastLinearToSlowEaseIn,
        );

    return Scaffold(
      appBar: suAppBar(
        context,
        title: titles[_currentPage.value],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (page) => _currentPage.value = page,
        children: [
          HomeTab(goToTab: goToTab),
          const TransactionsTab(),
          const SettingsTab(),
        ],
      ),
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
  }
}

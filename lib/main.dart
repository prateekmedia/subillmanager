import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:local_auth/local_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_strategy/url_strategy.dart';
import 'screens/screens.dart';
import 'models/models.dart';
import 'utils/utils.dart';

void main() async {
  setPathUrlStrategy();
  await GetStorage.init();
  await Hive.initFlutter();
  await Hive.openBox('DEMO');
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1280, 720);
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "SUbillManager";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    resetData();
    int themeMod() => GetStorage().read("thememode");

    final availableThemeModes = [
      ThemeMode.system,
      ThemeMode.light,
      ThemeMode.dark
    ];
    return GetMaterialApp(
      title: 'SUbillManager',
      theme: ThemeData(
        primarySwatch: primaryColor as MaterialColor?,
        primaryColor: primaryColor,
        brightness: Brightness.light,
        accentColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: primaryColor as MaterialColor?,
        primaryColor: primaryColor,
        brightness: Brightness.dark,
        accentColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: availableThemeModes[themeMod()],
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends HookWidget {
  PageController? _pageController;
  final box = GetStorage();
  String? _credentials;
  late String _spreadsheetId;
  late GSheets gsheets;
  late Spreadsheet ss;

  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sheet = useState<Worksheet?>(null);
    Future<List<List<String>>> initSheet() async {
      _credentials = box.read("googleID");
      _spreadsheetId = box.read("spreadID");
      if (_credentials != null && _credentials!.trim().isNotEmpty) {
        gsheets = GSheets(_credentials);

        // fetch spreadsheet by its id
        ss = await gsheets.spreadsheet(_spreadsheetId);
        // get worksheet by its index
        sheet.value = ss.worksheetByIndex(0);
        return sheet.value!.values.allColumns();
      }
      return [];
    }

    final _getTaskAsync = useMemoized(() => initSheet());
    final currentIndex = useState<int>(0);
    _pageController = usePageController();
    return Scaffold(
      body: Row(
        children: [
          if (!UniversalPlatform.isAndroid &&
              !UniversalPlatform.isIOS &&
              MediaQuery.of(context).size.width > 500)
            NavigationRail(
              backgroundColor: context.primaryColor,
              selectedIndex: currentIndex.value,
              onDestinationSelected: (int index) {
                currentIndex.value = index;
                _pageController!.animateToPage(index,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                navRailDestColor(context,
                    icon: Icons.account_balance_outlined,
                    activeIcon: Icons.account_balance,
                    label: "Home"),
                navRailDestColor(context,
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    label: "Settings"),
              ],
            ),
          Expanded(
              child: mainContent(
                  currentIndex, _getTaskAsync, _pageController, initSheet)),
        ],
      ),
      bottomNavigationBar: (UniversalPlatform.isAndroid ||
              UniversalPlatform.isIOS ||
              MediaQuery.of(context).size.width < 500)
          ? BottomNavigationBar(
              selectedItemColor: Colors.white,
              unselectedItemColor:
                  const Color(0xFF6C86A4).brighten(70).withAlpha(210),
              backgroundColor: context.primaryColor,
              currentIndex: currentIndex.value,
              onTap: (index) {
                currentIndex.value = index;
                _pageController!.animateToPage(index,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_outlined),
                    activeIcon: Icon(Icons.account_balance),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    activeIcon: Icon(Icons.settings),
                    label: 'Settings'),
              ],
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.bottomSheet(BottomSheet(
            getTaskAsync: _getTaskAsync,
            getWorksheet: sheet.value,
            setTaskAsync: initSheet)),
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        elevation: (UniversalPlatform.isAndroid ||
                UniversalPlatform.isIOS ||
                MediaQuery.of(context).size.width < 500)
            ? null
            : 0,
        backgroundColor: context.primaryColor,
      ),
      floatingActionButtonLocation: (UniversalPlatform.isAndroid ||
              UniversalPlatform.isIOS ||
              MediaQuery.of(context).size.width < 500)
          ? FloatingActionButtonLocation.miniEndDocked
          : FloatingActionButtonLocation.miniStartFloat,
    );
  }

  NavigationRailDestination navRailDestColor(BuildContext context,
      {IconData? icon, IconData? activeIcon, required String label}) {
    return NavigationRailDestination(
      icon: Icon(icon,
          color: const Color(0xFF6C86A4).brighten(70).withAlpha(210)),
      selectedIcon: Icon(
        activeIcon,
        color: primaryColor.brighten(90),
      ),
      label: Text(
        label,
        style: TextStyle(color: primaryColor.brighten(95)),
      ),
    );
  }

  SizedBox mainContent(
      var currentIndex,
      Future<List<List<String>>> _getTaskAsync,
      PageController? pageController,
      Function initSheet) {
    return SizedBox.expand(
      child: PageView(
        controller: pageController,
        onPageChanged: (index) {
          currentIndex.value = index;
        },
        children: [
          HomeScreen(_getTaskAsync,
              initSheet as Future<List<List<String>>> Function()),
          const SettingsScreen(),
        ],
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}

class BottomSheet extends HookWidget {
  BottomSheet({
    Key? key,
    required Future<List<List<String>>> getTaskAsync,
    required this.setTaskAsync,
    required this.getWorksheet,
  })  : _getTaskAsync = getTaskAsync,
        super(key: key);

  final Future<List<List<String>>> _getTaskAsync;
  final Worksheet? getWorksheet;
  final LocalAuthentication auth = LocalAuthentication();
  final Future<List<List<String>>> Function() setTaskAsync;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController? _dateController = useTextEditingController(
      text: DateFormat('MMMM dd').format(DateTime.now()),
    );
    final TextEditingController? _unitController =
        useTextEditingController(text: "256.0");
    final pageNo = useState<int>(0); // Up to 1 as there are two people
    final listBills = useState<List<BillModel>>([]);
    final _authorized = useState<bool>(false);
    var gTaskSync = useState(useMemoized(() => _getTaskAsync));
    Future<void> _authenticate() async {
      bool authenticated = _authorized.value;
      if (UniversalPlatform.isWeb) {
        authenticated = true;
      } else {
        try {
          if (!authenticated) {
            authenticated = await auth.authenticate(
                localizedReason: 'Authenticate to Add a Field',
                useErrorDialogs: true,
                stickyAuth: true);
          }
        } on PlatformException catch (_) {
          authenticated = true;
        }
      }

      _authorized.value = authenticated;
    }

    if (!_authorized.value) _authenticate();
    bool demoMode = GetStorage().read("demo");
    final loading = useState<bool>(false);
    gTaskSync.value = setTaskAsync();

    return FutureBuilder<List>(
        future:
            Future.value(Hive.box('DEMO').get('demo', defaultValue: demoData)),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    constraints: const BoxConstraints(maxHeight: 400),
                    width: (UniversalPlatform.isAndroid ||
                            UniversalPlatform.isIOS ||
                            context.width < 500)
                        ? context.width * 0.96
                        : 500,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    decoration: BoxDecoration(
                        color: context.isDark ? Colors.grey[900] : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: Stack(
                      children: [
                        if (demoMode)
                          const Align(
                            alignment: Alignment.topRight,
                            child: Text("DEMO"),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _authorized.value
                              ? [
                                  !loading.value &&
                                          snapshot.hasData &&
                                          snapshot.data!.isNotEmpty
                                      ? Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                          "ADD NEW BILL",
                                                          style: context
                                                              .texttheme
                                                              .headline6)),
                                                  Text(
                                                      " ( ${[
                                                        snapshot.data![1][0]
                                                            .split(" ")[0],
                                                        snapshot.data![4][0]
                                                            .split(" ")[0],
                                                      ][pageNo.value]} )",
                                                      style: context
                                                          .texttheme.bodyText1!
                                                          .copyWith(
                                                              fontSize: 18)),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              customInputField(
                                                  context,
                                                  _dateController,
                                                  (pageNo.value == 0
                                                      ? true
                                                      : false)),
                                              const SizedBox(height: 10),
                                              customInputField(
                                                  context, _unitController),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  if (pageNo.value == 0)
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                              primary: context
                                                                  .textTheme
                                                                  .headline6!
                                                                  .color!
                                                                  .withAlpha(
                                                                      180)),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text("CLOSE"),
                                                    ),
                                                  if (pageNo.value == 0)
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                              primary: context
                                                                  .textTheme
                                                                  .headline6!
                                                                  .color),
                                                      onPressed: () {
                                                        listBills.value
                                                            .add(BillModel(
                                                          id: 1,
                                                          date: _dateController!
                                                              .text,
                                                          unit: _unitController!
                                                              .text,
                                                        ));
                                                        _unitController.text =
                                                            "256.0";
                                                        pageNo.value = 1;
                                                      },
                                                      child: const Text("NEXT"),
                                                    ),
                                                  if (pageNo.value == 1)
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                              primary: context
                                                                  .textTheme
                                                                  .headline6!
                                                                  .color!
                                                                  .withAlpha(
                                                                      180)),
                                                      onPressed: () {
                                                        _dateController!.text =
                                                            listBills
                                                                .value[0].date!;
                                                        _unitController!.text =
                                                            listBills
                                                                .value[0].unit!;
                                                        listBills.value
                                                            .removeAt(0);
                                                        pageNo.value = 0;
                                                      },
                                                      child: const Text("BACK"),
                                                    ),
                                                  if (pageNo.value == 1)
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                              primary: context
                                                                  .textTheme
                                                                  .headline6!
                                                                  .color),
                                                      onPressed: demoMode
                                                          ? () {
                                                              Get.back();
                                                              Get.showSnackbar(GetBar(
                                                                  backgroundColor:
                                                                      primaryColor,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          1500),
                                                                  message:
                                                                      "Demo Complete"));
                                                            }
                                                          : () async {
                                                              loading.value =
                                                                  true;
                                                              listBills.value
                                                                  .add(
                                                                      BillModel(
                                                                id: 4,
                                                                date:
                                                                    _dateController!
                                                                        .text,
                                                                unit:
                                                                    _unitController!
                                                                        .text,
                                                              ));
                                                              var cell1 = await getWorksheet!.cells.cell(
                                                                  row: snapshot
                                                                          .data![
                                                                              0]
                                                                          .length +
                                                                      1,
                                                                  column: 1);
                                                              var cell2 = await getWorksheet!.cells.cell(
                                                                  row: snapshot
                                                                          .data![
                                                                              0]
                                                                          .length +
                                                                      1,
                                                                  column: 2);
                                                              var cell5 = await getWorksheet!.cells.cell(
                                                                  row: snapshot
                                                                          .data![
                                                                              0]
                                                                          .length +
                                                                      1,
                                                                  column: 5);
                                                              await cell1.post(
                                                                  listBills
                                                                      .value[0]
                                                                      .date);
                                                              await cell2.post(
                                                                  listBills
                                                                      .value[0]
                                                                      .unit);
                                                              await cell5.post(
                                                                  listBills
                                                                      .value[1]
                                                                      .unit);
                                                              Get.back();
                                                              Get.showSnackbar(GetBar(
                                                                  backgroundColor:
                                                                      primaryColor,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          1500),
                                                                  message:
                                                                      "Succesfully added to Sheets"));
                                                            },
                                                      child: const Text("DONE"),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : snapshot.hasData && !loading.value
                                          ? const Center(
                                              child: Text(
                                                  "NO Data Available, Configure Credentials First"))
                                          : snapshot.connectionState !=
                                                      ConnectionState.done ||
                                                  loading.value
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(primaryColor),
                                                ))
                                              : snapshot.hasError
                                                  ? Column(
                                                      children: [
                                                        Text(snapshot.error
                                                            .toString()),
                                                        TextButton(
                                                          child: const Text(
                                                              "Refresh"),
                                                          onPressed: () =>
                                                              gTaskSync.value =
                                                                  setTaskAsync(),
                                                        )
                                                      ],
                                                    )
                                                  : Container(),
                                ]
                              : [
                                  const Center(
                                      child:
                                          Text("You are not authenticated.")),
                                  const SizedBox(height: 15),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        primary: context
                                            .textTheme.headline6!.color!
                                            .withAlpha(180)),
                                    onPressed: _authenticate,
                                    child: const Text("Auth Now"),
                                  ),
                                ],
                        ),
                      ],
                    )),
              ],
            ),
          );
        });
  }

  Widget customInputField(
      BuildContext context, TextEditingController? controller,
      [bool enabled = true]) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: context.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor.brighten(70), width: 1.0),
        ),
      ),
    );
  }
}

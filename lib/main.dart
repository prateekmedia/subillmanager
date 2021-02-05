import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'routes.dart';
import 'models.dart';
import 'utils.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GetStorage().writeIfNull("thememode", 0);
    int themeMod() => GetStorage().read("thememode");

    final availableThemeModes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    return GetMaterialApp(
      title: 'SUbillManager',
      theme: ThemeData(
        primarySwatch: primaryColor,
        primaryColor: primaryColor,
        brightness: Brightness.light,
        accentColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: primaryColor,
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
  PageController _pageController;
  final box = GetStorage();
  String _credentials;
  String _spreadsheetId;
  GSheets gsheets;
  Spreadsheet ss;
  Worksheet sheet;

  Future<List<List<String>>> initSheet() async {
    _credentials = box.read("googleID");
    _spreadsheetId = box.read("spreadID");
    if (_credentials != null && _credentials.trim().length > 0) {
      gsheets = GSheets(_credentials);

      // fetch spreadsheet by its id
      ss = await gsheets.spreadsheet(_spreadsheetId);
      // get worksheet by its index
      sheet = ss.worksheetByIndex(0);
      return sheet.values.allColumns();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final _getTaskAsync = useMemoized(() => initSheet());
    final currentIndex = useState<int>(0);
    _pageController = usePageController();
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            currentIndex.value = index;
          },
          children: [
            HomeScreen(_getTaskAsync, initSheet),
            SettingsScreen(),
          ],
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: context.isDark ? primaryColor.brighten(50) : primaryColor,
        unselectedItemColor:
            context.isDark ? Color(0xFF6C86A4).brighten(50).withAlpha(170) : Color(0xFF6C86A4),
        backgroundColor: context.isDark ? Colors.grey[900].brighten(12) : grey,
        currentIndex: currentIndex.value,
        onTap: (index) {
          currentIndex.value = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 150), curve: Curves.easeOut);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_outlined),
              activeIcon: Icon(Icons.account_balance),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.bottomSheet(
            BottomSheet(getTaskAsync: _getTaskAsync, getWorksheet: sheet, setTaskAsync: initSheet)),
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class BottomSheet extends HookWidget {
  BottomSheet({
    Key key,
    @required Future<List<List<String>>> getTaskAsync,
    @required this.setTaskAsync,
    @required this.getWorksheet,
  })  : _getTaskAsync = getTaskAsync,
        super(key: key);

  final Future<List<List<String>>> _getTaskAsync;
  final Worksheet getWorksheet;
  final LocalAuthentication auth = LocalAuthentication();
  final Future<List<List<String>>> Function() setTaskAsync;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _dateController = useTextEditingController(
      text: DateFormat('MMMM dd').format(DateTime.now()),
    );
    final _unitController = useTextEditingController(text: "256.0");
    final pageNo = useState<int>(0); // Up to 1 as there are two people
    final listBills = useState<List<BillModel>>([]);
    final _authorized = useState<bool>(false);
    var gTaskSync = useState(useMemoized(() => _getTaskAsync));
    Future<void> _authenticate() async {
      bool authenticated = false;
      try {
        _authorized.value = false;
        authenticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Scan your fingerprint to Add a Field',
            useErrorDialogs: true,
            stickyAuth: true);

        _authorized.value = false;
      } on PlatformException catch (e) {
        print(e);
      }

      _authorized.value = authenticated;
    }

    if (!_authorized.value) _authenticate();

    return FutureBuilder(
        future: gTaskSync.value,
        builder: (context, snapshot) {
          return Container(
              height: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: context.isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: _authorized.value
                      ? [
                          snapshot.hasData && snapshot.data.length > 0
                              ? Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(vertical: 20),
                                          child: Text("Add New Bill",
                                              style: context.texttheme.headline6)),
                                      Text(
                                          [
                                            snapshot.data[1][0].split(" ")[0],
                                            snapshot.data[4][0].split(" ")[0],
                                          ][pageNo.value],
                                          style:
                                              context.texttheme.bodyText1.copyWith(fontSize: 18)),
                                      TextFormField(
                                        controller: _dateController,
                                        enabled: (pageNo.value == 0) ? true : false,
                                        decoration: InputDecoration(),
                                      ),
                                      TextFormField(
                                        controller: _unitController,
                                        decoration: InputDecoration(),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          if (pageNo.value == 0)
                                            FlatButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text("CLOSE"),
                                            ),
                                          if (pageNo.value == 0)
                                            FlatButton(
                                              onPressed: () {
                                                listBills.value.add(BillModel(
                                                  id: 1,
                                                  date: _dateController.text,
                                                  unit: _unitController.text,
                                                ));
                                                _unitController.text = "256.0";
                                                pageNo.value = 1;
                                              },
                                              child: Text("NEXT"),
                                            ),
                                          if (pageNo.value == 1)
                                            FlatButton(
                                              onPressed: () {
                                                _dateController.text = listBills.value[0].date;
                                                _unitController.text = listBills.value[0].unit;
                                                listBills.value.removeAt(0);
                                                pageNo.value = 0;
                                              },
                                              child: Text("BACK"),
                                            ),
                                          if (pageNo.value == 1)
                                            FlatButton(
                                              onPressed: () async {
                                                listBills.value.add(BillModel(
                                                  id: 4,
                                                  date: _dateController.text,
                                                  unit: _unitController.text,
                                                ));
                                                var cell1 = await getWorksheet.cells.cell(
                                                    row: snapshot.data[0].length + 1, column: 1);
                                                var cell2 = await getWorksheet.cells.cell(
                                                    row: snapshot.data[0].length + 1, column: 2);
                                                var cell5 = await getWorksheet.cells.cell(
                                                    row: snapshot.data[0].length + 1, column: 5);
                                                await cell1.post(listBills.value[0].date);
                                                await cell2.post(listBills.value[0].unit);
                                                await cell5.post(listBills.value[1].unit);

                                                Navigator.pop(context);
                                              },
                                              child: Text("DONE"),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : snapshot.hasData
                                  ? Center(
                                      child: Text("NO Data Available, Configure Credentials First"))
                                  : snapshot.connectionState != ConnectionState.done
                                      ? Center(child: CircularProgressIndicator())
                                      : snapshot.hasError
                                          ? Column(
                                              children: [
                                                Text(snapshot.error.toString()),
                                                FlatButton(
                                                  child: Text("Refresh"),
                                                  onPressed: () => gTaskSync.value = setTaskAsync(),
                                                )
                                              ],
                                            )
                                          : Container(),
                        ]
                      : [
                          Center(child: Text("You are not authenticated.")),
                          FlatButton(
                            onPressed: _authenticate,
                            child: Text("Auth Now"),
                          ),
                        ],
                ),
              ));
        });
  }
}

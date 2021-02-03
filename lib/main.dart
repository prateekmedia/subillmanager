import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
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
    return GetMaterialApp(
      title: 'SUbillManager',
      theme: ThemeData(
        primarySwatch: MaterialColor(primaryColor.value, colorSwatch),
        primaryColor: primaryColor,
        brightness: Brightness.light,
        accentColor: MaterialColor(primaryColor.value, colorSwatch).shade700,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: MaterialColor(primaryColor.value, colorSwatch),
        primaryColor: primaryColor,
        brightness: Brightness.dark,
        accentColor: MaterialColor(primaryColor.value, colorSwatch).shade700,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.light,
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

  Future<Worksheet> initSheet() async {
    _credentials = box.read("googleID");
    _spreadsheetId = box.read("spreadID");
    gsheets = GSheets(_credentials);

    // fetch spreadsheet by its id
    ss = await gsheets.spreadsheet(_spreadsheetId);
    // get worksheet by its index
    sheet = ss.worksheetByIndex(0);
    return _credentials != null ? sheet.values.allColumns() : [];
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
            HomeScreen(_getTaskAsync),
            SettingsScreen(),
          ],
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF6C86A4),
        backgroundColor: grey,
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
        onPressed: () =>
            Get.bottomSheet(BottomSheet(getTaskAsync: _getTaskAsync, formKey: _formKey)),
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class BottomSheet extends HookWidget {
  const BottomSheet({
    Key key,
    @required Future<Worksheet> getTaskAsync,
    @required GlobalKey<FormState> formKey,
  })  : _getTaskAsync = getTaskAsync,
        _formKey = formKey,
        super(key: key);

  final Future<Worksheet> _getTaskAsync;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    final _dateController = useTextEditingController(
      text: DateFormat('MMMM dd').format(DateTime.now()),
    );
    final getWorkSheet = useMemoized(() async => (await _getTaskAsync).values.allColumns());
    final _unitController = useTextEditingController(text: "256.0");
    final pageNo = useState<int>(0); // Up to 1 as there are two people
    final listBills = useState<List<BillModel>>([]);
    return FutureBuilder(
        future: getWorkSheet,
        builder: (context, snapshot) {
          return Container(
              color: Colors.white,
              height: 400,
              padding: EdgeInsets.all(20),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    snapshot.hasData && snapshot.data.length > 0
                        ? Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child:
                                        Text("Add New Bill", style: context.texttheme.headline6)),
                                Text([
                                  snapshot.data[1][0].split(" ")[0],
                                  snapshot.data[4][0].split(" ")[0],
                                ][pageNo.value]),
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
                                          _dateController.text =
                                              DateFormat('MMMM dd').format(DateTime.now());
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
                                          var cell1 = await (await _getTaskAsync)
                                              .cells
                                              .cell(row: snapshot.data[0].length, column: 0);
                                          var cell2 = await (await _getTaskAsync)
                                              .cells
                                              .cell(row: snapshot.data[0].length, column: 1);
                                          var cell5 = await (await _getTaskAsync)
                                              .cells
                                              .cell(row: snapshot.data[0].length, column: 4);
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
                        : Center(child: CircularProgressIndicator()),
                  ],
                ),
              ));
        });
  }
}

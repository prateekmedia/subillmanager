import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../utils.dart';
import '../widgets.dart';

class HomeScreen extends StatefulHookWidget {
  final Future<Worksheet> getTaskAsync;

  HomeScreen(this.getTaskAsync);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final getWorkSheet = useMemoized(() async => (await widget.getTaskAsync).values.allColumns());
    final showOnly = useState<int>(0);
    return FutureBuilder<List<List<String>>>(
        future: getWorkSheet,
        builder: (context, snapshot) {
          bool hasData = snapshot.hasData && snapshot.data.length > 0;
          return AwesomePopCard(
            context,
            headerChildren: [
              Column(
                children: [
                  Text(
                    (hasData)
                        ? "₹${int.parse(snapshot.data[3].reversed.toList()[0].substring(1)) + int.parse(snapshot.data[6].reversed.toList()[0].substring(1))}"
                        : "₹0.0",
                    style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
                  ),
                  Text(
                    "Last month bill",
                    style:
                        Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey.shade300),
                  ),
                ],
              ),
              (hasData)
                  ? Icon(Icons.account_circle, color: Colors.white)
                  : IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: null,
                    ),
            ],
            footerChildren: (hasData)
                ? [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text("Recent Bills",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FlatButton(
                          onPressed: () => showOnly.value = 0,
                          child: Text("All",
                              style: TextStyle(
                                  color: showOnly.value == 0 ? primaryColor : Colors.grey)),
                        ),
                        FlatButton(
                          onPressed: () => showOnly.value = 1,
                          child: Text(snapshot.data[1][0].split(" ")[0],
                              style: TextStyle(
                                  color: showOnly.value == 1 ? primaryColor : Colors.grey)),
                        ),
                        FlatButton(
                          onPressed: () => showOnly.value = 2,
                          child: Text(snapshot.data[4][0].split(" ")[0],
                              style: TextStyle(
                                  color: showOnly.value == 2 ? primaryColor : Colors.grey)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    for (int i = 0; i < snapshot.data.length - 1; i++)
                      AwesomeMonthBill(
                        context,
                        title: snapshot.data[0].reversed.toList()[i],
                        children: [
                          if (showOnly.value == 0 || showOnly.value == 1)
                            AwesomeListTile(
                              context,
                              icon: Icons.person_outlined,
                              title: snapshot.data[1][0].split(" ")[0],
                              subtitle: "Feb 1",
                              trailing: snapshot.data[3].reversed.toList()[i],
                            ),
                          if (showOnly.value == 0 || showOnly.value == 2)
                            AwesomeListTile(
                              context,
                              icon: Icons.person_outlined,
                              title: snapshot.data[4][0].split(" ")[0],
                              subtitle: "Feb 1",
                              trailing: snapshot.data[6].reversed.toList()[i],
                            ),
                        ],
                      ),
                  ]
                : snapshot.hasData
                    ? [Center(child: Text("No Data Available, Configure Credentials first."))]
                    : [Center(child: CircularProgressIndicator())],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

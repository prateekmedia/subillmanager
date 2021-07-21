import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulHookWidget {
  final Future<List<List<String>>> getTaskAsync;
  final Future<List<List<String>>> Function() setTaskAsync;

  const HomeScreen(this.getTaskAsync, this.setTaskAsync, {Key? key})
      : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final showOnly = useState<int>(0);
    var gTaskSync = useState(useMemoized(() => widget.getTaskAsync));
    var demoMode = GetStorage().read("demo");
    List demoM = Hive.box('DEMO').get('demo', defaultValue: demoData);
    return FutureBuilder<List>(
        future: demoMode ? Future.value(demoM) : gTaskSync.value,
        builder: (context, snapshot) {
          bool hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
          return AwesomePopCard(
            context,
            headerChildren: [
              Column(
                children: [
                  Text(
                    (hasData)
                        ? "₹${(double.parse(snapshot.data![3].reversed.toList()[0].substring(1)) + double.parse(snapshot.data![6].reversed.toList()[0].substring(1))).toStringAsFixed(1)}"
                        : "₹0.0",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    "Last month bill",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.grey.shade300),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  if (demoMode)
                    IconButton(
                      icon: const Icon(
                        Icons.developer_mode,
                        color: Colors.white,
                      ),
                      tooltip: "Turn off Demo Mode",
                      onPressed: () {
                        GetStorage().write("demo", false);
                        setState(() {
                          demoMode = GetStorage().read("demo");
                        });
                      },
                    ),
                  if (!demoMode)
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      tooltip: "Refresh Data",
                      onPressed: () {
                        demoMode = GetStorage().read("demo");
                        if (demoMode) {
                          gTaskSync.value = Future.value(demoData);
                        }
                        gTaskSync.value = widget.setTaskAsync();
                      },
                    ),
                  const SizedBox(width: 20),
                  if (hasData &&
                      !demoMode &&
                      !const DeepCollectionEquality()
                          .equals(snapshot.data, demoM))
                    IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      tooltip: "Update Cache",
                      onPressed: () {
                        Hive.box('DEMO').put('demo', snapshot.data);
                        GetStorage().write("demo", true);
                        setState(() {
                          demoMode = GetStorage().read("demo");
                        });
                      },
                    ),
                  if (!demoMode &&
                      (!hasData ||
                          const DeepCollectionEquality()
                              .equals(snapshot.data, demoM)))
                    IconButton(
                      icon: const Icon(
                        Icons.center_focus_strong_outlined,
                        color: Colors.white,
                      ),
                      tooltip: "Turn on Demo Mode",
                      onPressed: () {
                        GetStorage().write("demo", true);
                        setState(() {
                          demoMode = GetStorage().read("demo");
                        });
                      },
                    ),
                ],
              ),
            ],
            centerWidget: hasData ? false : true,
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
                                  .headline5!
                                  .copyWith(
                                      color: context.isDark
                                          ? primaryColor.brighten(90)
                                          : primaryColor,
                                      fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => showOnly.value = 0,
                          child: Text("All",
                              style: TextStyle(
                                  color: showOnly.value == 0
                                      ? context.isDark
                                          ? primaryColor.brighten(80)
                                          : primaryColor
                                      : Colors.grey)),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () => showOnly.value = 1,
                          child: Text(snapshot.data![1][0].split(" ")[0],
                              style: TextStyle(
                                  color: showOnly.value == 1
                                      ? context.isDark
                                          ? primaryColor.brighten(80)
                                          : primaryColor
                                      : Colors.grey)),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () => showOnly.value = 2,
                          child: Text(snapshot.data![4][0].split(" ")[0],
                              style: TextStyle(
                                  color: showOnly.value == 2
                                      ? context.isDark
                                          ? primaryColor.brighten(80)
                                          : primaryColor
                                      : Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < snapshot.data![0].length - 1; i++)
                      AwesomeMonthBill(
                        context,
                        title: snapshot.data![0].reversed.toList()[i],
                        visible: (showOnly.value == 0)
                            ? (double.parse(snapshot.data![3].reversed
                                            .toList()[i]
                                            .substring(1)) +
                                        double.parse(snapshot.data![6].reversed
                                            .toList()[i]
                                            .substring(1)))
                                    .toStringAsFixed(1) !=
                                "0.0"
                            : (showOnly.value == 1)
                                ? double.parse(snapshot.data![3].reversed
                                            .toList()[i]
                                            .substring(1))
                                        .toStringAsFixed(1) !=
                                    "0.0"
                                : (showOnly.value == 2)
                                    ? double.parse(snapshot.data![6].reversed
                                                .toList()[i]
                                                .substring(1))
                                            .toStringAsFixed(1) !=
                                        "0.0"
                                    : true,
                        children: [
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: context.isDark
                                      ? Colors.black38
                                      : Colors.grey[200]!.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Column(children: [
                              if (showOnly.value == 0 || showOnly.value == 1)
                                AwesomeListTile(
                                  context,
                                  icon: Icons.person_outlined,
                                  visible: double.parse(snapshot
                                              .data![3].reversed
                                              .toList()[i]
                                              .substring(1))
                                          .toStringAsFixed(1) !=
                                      "0.0",
                                  title: snapshot.data![1][0].split(" ")[0],
                                  subtitle: double.parse(snapshot
                                              .data![2].reversed
                                              .toList()[i])
                                          .toStringAsFixed(1) +
                                      " UNIT",
                                  trailing:
                                      snapshot.data![3].reversed.toList()[i],
                                ),
                              if (showOnly.value == 0 || showOnly.value == 2)
                                AwesomeListTile(
                                  context,
                                  icon: Icons.person_outlined,
                                  visible: double.parse(snapshot
                                              .data![6].reversed
                                              .toList()[i]
                                              .substring(1))
                                          .toStringAsFixed(1) !=
                                      "0.0",
                                  title: snapshot.data![4][0].split(" ")[0],
                                  subtitle: double.parse(snapshot
                                              .data![5].reversed
                                              .toList()[i])
                                          .toStringAsFixed(1) +
                                      " UNIT",
                                  trailing:
                                      snapshot.data![6].reversed.toList()[i],
                                ),
                            ]),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    const SizedBox(height: 25),
                  ]
                : snapshot.hasData
                    ? [
                        const Text(
                            "NO Data Available, Configure Credentials First"),
                      ]
                    : snapshot.connectionState != ConnectionState.done
                        ? [
                            CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(primaryColor))
                          ]
                        : snapshot.hasError
                            ? [Text(snapshot.error.toString())]
                            : [Container()],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

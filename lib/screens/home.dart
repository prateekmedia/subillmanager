import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulHookWidget {
  final AsyncSnapshot<List> snapshot;

  const HomeScreen({Key? key, required this.snapshot}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final showOnly = useState<int>(0);
    bool hasData = widget.snapshot.hasData && widget.snapshot.data!.isNotEmpty;
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      children: (hasData)
          ? [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Text("Recent Bills",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: context.isDark ? primaryColor.brighten(90) : primaryColor,
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
                    child: Text(widget.snapshot.data![1][0].split(" ")[0],
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
                    child: Text(widget.snapshot.data![4][0].split(" ")[0],
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
              for (int i = 0; i < widget.snapshot.data![0].length - 1; i++)
                AwesomeMonthBill(
                  context,
                  title: widget.snapshot.data![0].reversed.toList()[i],
                  visible: (showOnly.value == 0)
                      ? (double.parse(widget.snapshot.data![3].reversed.toList()[i].substring(1)) +
                                  double.parse(widget.snapshot.data![6].reversed.toList()[i].substring(1)))
                              .toStringAsFixed(1) !=
                          "0.0"
                      : (showOnly.value == 1)
                          ? double.parse(widget.snapshot.data![3].reversed.toList()[i].substring(1))
                                  .toStringAsFixed(1) !=
                              "0.0"
                          : (showOnly.value == 2)
                              ? double.parse(widget.snapshot.data![6].reversed.toList()[i].substring(1))
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
                            color: context.isDark ? Colors.black38 : Colors.grey[200]!.withOpacity(0.5),
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
                            visible: double.parse(widget.snapshot.data![3].reversed.toList()[i].substring(1))
                                    .toStringAsFixed(1) !=
                                "0.0",
                            title: widget.snapshot.data![1][0].split(" ")[0],
                            subtitle: double.parse(widget.snapshot.data![2].reversed.toList()[i]).toStringAsFixed(1) +
                                " UNIT",
                            trailing: widget.snapshot.data![3].reversed.toList()[i],
                          ),
                        if (showOnly.value == 0 || showOnly.value == 2)
                          AwesomeListTile(
                            context,
                            icon: Icons.person_outlined,
                            visible: double.parse(widget.snapshot.data![6].reversed.toList()[i].substring(1))
                                    .toStringAsFixed(1) !=
                                "0.0",
                            title: widget.snapshot.data![4][0].split(" ")[0],
                            subtitle: double.parse(widget.snapshot.data![5].reversed.toList()[i]).toStringAsFixed(1) +
                                " UNIT",
                            trailing: widget.snapshot.data![6].reversed.toList()[i],
                          ),
                      ]),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              const SizedBox(height: 25),
            ]
          : widget.snapshot.hasData
              ? [
                  noCredentials,
                ]
              : widget.snapshot.connectionState != ConnectionState.done
                  ? [
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      )
                    ]
                  : widget.snapshot.hasError
                      ? [Text(widget.snapshot.error.toString())]
                      : [Container()],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

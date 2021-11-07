import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_platform/universal_platform.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

GetStorage box = GetStorage();

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var demo = useState(box.read("demo"));
    List demoD = Hive.box('DEMO').get('demo') ?? List.empty();
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      children: [
        ListTile(
          leading: const Icon(Icons.data_usage),
          title: const Text("Update Credentials"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const ConfigureCredentials()),
          ),
        ),
        ListTile(
          title: const Text("Dark Mode"),
          leading: const Icon(Icons.nightlight_round),
          trailing: CupertinoSwitch(
            value: context.isDark,
            activeColor: primaryColor.brighten(20),
            onChanged: (v) {
              Get.changeThemeMode(context.isDark ? ThemeMode.light : ThemeMode.dark);
              box.write("thememode", v ? 2 : 1);
            },
          ),
          onTap: () {
            box.write("thememode", context.isDark ? 1 : 2);
            Get.changeThemeMode(context.isDark ? ThemeMode.light : ThemeMode.dark);
          },
        ),
        ListTile(
          title: Text(demoD.isEmpty || demoD == demoData ? "Demo Mode" : "Cache Mode"),
          leading: const Icon(Icons.developer_mode_outlined),
          trailing: CupertinoSwitch(
            value: demo.value,
            activeColor: primaryColor.brighten(20),
            onChanged: (v) {
              box.write("demo", v);
              demo.value = v;
            },
          ),
          onTap: () {
            demo.value = !demo.value;
            box.write("demo", demo.value);
          },
        ),
        ListTile(
          leading: const Icon(Icons.remove_from_queue),
          title: const Text("Clear Data"),
          onTap: () => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Are you Sure?"),
              content: const Text("This will reset all of you data."),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(primary: context.isDarkMode ? Colors.grey[200]! : primaryColor),
                  child: const Text("CANCEL"),
                  onPressed: Get.back,
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: context.textTheme.bodyText2!.color),
                  child: const Text("YES"),
                  onPressed: () {
                    GetStorage().erase();
                    Get.changeThemeMode(ThemeMode.system);
                    resetData();
                    Hive.box('DEMO').clear();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ConfigureCredentials extends StatefulWidget {
  const ConfigureCredentials({Key? key}) : super(key: key);
  @override
  _ConfigureCredentialsState createState() => _ConfigureCredentialsState();
}

class _ConfigureCredentialsState extends State<ConfigureCredentials> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _authorized = false;

  Future<void> _authenticate() async {
    bool authenticated = _authorized;
    if (UniversalPlatform.isWeb) {
      authenticated = true;
    } else {
      try {
        if (!authenticated) {
          authenticated = await auth.authenticate(
              localizedReason: 'Authenticate to Update Credentials', useErrorDialogs: true, stickyAuth: true);
        }
      } on PlatformException catch (_) {
        authenticated = true;
      }
    }
    if (!mounted) return;

    setState(() => _authorized = authenticated);
  }

  @override
  void initState() {
    _authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final spreadID = TextEditingController(text: box.read("spreadID"));
    final googleID = TextEditingController(text: box.read("googleID"));
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: AwesomePopCard(
        context,
        tag: "header",
        headerChildren: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("Update Credentials",
                  overflow: TextOverflow.ellipsis,
                  style: context.texttheme.headline6!.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
        headerMainAxisAlignment: MainAxisAlignment.start,
        centerWidget: !_authorized ? true : false,
        footerPadding: const EdgeInsets.all(15),
        footerChildren: !_authorized
            ? [
                const Text("You are not authenticated."),
              ]
            : [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Spreadsheet ID"),
                      TextFormField(
                        controller: spreadID,
                        decoration: const InputDecoration(),
                      ),
                      const SizedBox(height: 50),
                      const Text("Google Client ID"),
                      TextFormField(
                        controller: googleID,
                        decoration: const InputDecoration(),
                        maxLines: null,
                      ),
                    ],
                  ),
                )
              ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _authorized
            ? () {
                if (spreadID.text.trim().isNotEmpty) {
                  box.write("spreadID", spreadID.text);
                }
                if (googleID.text.trim().isNotEmpty) {
                  box.write("googleID", googleID.text);
                }
                Navigator.pop(context);
              }
            : _authenticate,
        label: Text(_authorized ? "CONFIRM" : "AUTH NOW"),
        icon: Icon(_authorized ? Icons.check : Icons.security_outlined),
      ),
    );
  }
}

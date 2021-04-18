import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_platform/universal_platform.dart';
import '../utils.dart';
import '../widgets.dart';

GetStorage box = GetStorage();

class SettingsScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var demo = useState(box.read("demo"));
    List demoD = Hive.box('DEMO').get('demo') ?? List.empty();
    return AwesomePopCard(
      context,
      tag: "header",
      headerChildren: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Settings",
              style: context.texttheme.headline6!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ],
      centerWidget: false,
      footerChildren: [
        ListTile(
          leading: Icon(Icons.data_usage),
          title: Text("Update Credentials"),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => ConfigureCredentials()),
          ),
        ),
        ListTile(
          title: Text("Dark Mode"),
          leading: Icon(Icons.nightlight_round),
          trailing: CupertinoSwitch(
            value: context.isDark,
            activeColor: primaryColor.brighten(20),
            onChanged: (v) {
              Get.changeThemeMode(
                  context.isDark ? ThemeMode.light : ThemeMode.dark);
              box.write("thememode", v ? 2 : 1);
            },
          ),
          onTap: () {
            box.write("thememode", context.isDark ? 1 : 2);
            Get.changeThemeMode(
                context.isDark ? ThemeMode.light : ThemeMode.dark);
          },
        ),
        ListTile(
          title: Text(
              demoD.isEmpty || demoD == demoData ? "Demo Mode" : "Cache Mode"),
          leading: Icon(Icons.developer_mode_outlined),
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
          leading: Icon(Icons.remove_from_queue),
          title: Text("Clear Data"),
          onTap: () => showDialog(
            context: context,
                      builder: (ctx)=>AlertDialog(
                title: Text("Are you Sure?"),
                content: Container(
                    child: Text(
                        "This will reset all of you data.")),
                actions: [TextButton(
                      style: TextButton.styleFrom(
                          primary: context.isDarkMode ? Colors.grey[200]! : primaryColor),
                      child: Text("CANCEL"),
                      onPressed: Get.back,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: context.textTheme.bodyText2!.color),
                      child: Text("YES"),
                      onPressed: () {
                  GetStorage().erase();
                  Get.changeThemeMode(ThemeMode.system);
                  resetData();
                  Hive.box('DEMO').clear();
                  Get.back();
                      },
                    ),],),
          ),
        ),
      ],
    );
  }
}

class ConfigureCredentials extends StatefulWidget {
  @override
  _ConfigureCredentialsState createState() => _ConfigureCredentialsState();
}

class _ConfigureCredentialsState extends State<ConfigureCredentials> {
  final LocalAuthentication auth = LocalAuthentication();
  Future<void> _authenticate() async {
    bool authenticated = false;
    if (UniversalPlatform.isWeb)
      authenticated = true;
    else {
      try {
        authenticated = await auth.authenticate(
            localizedReason: 'Scan your fingerprint to Update Credentials',
            useErrorDialogs: true,
            stickyAuth: true);
        if (!mounted) return;
      } on PlatformException catch (_) {
        authenticated = true;
      }
    }
    if (!mounted) return;

    setState(() => _authorized = authenticated);
  }

  bool _authorized = false;
  @override
  void initState() {
    _authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final spreadID = TextEditingController(text: box.read("spreadID"));
    final googleID = TextEditingController(text: box.read("googleID"));
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: AwesomePopCard(
        context,
        tag: "header",
        headerChildren: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Update Credentials",
                style: context.texttheme.headline6!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
        headerMainAxisAlignment: MainAxisAlignment.start,
        centerWidget: !_authorized ? true : false,
        footerChildren: !_authorized
            ? [
                Text("You are not authenticated."),
              ]
            : [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Spreadsheet ID"),
                      TextFormField(
                        controller: spreadID,
                        decoration: InputDecoration(),
                      ),
                      SizedBox(height: 50),
                      Text("Google Client ID"),
                      TextFormField(
                        controller: googleID,
                        decoration: InputDecoration(),
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
                if (spreadID.text.trim().length > 0)
                  box.write("spreadID", spreadID.text);
                if (googleID.text.trim().length > 0)
                  box.write("googleID", googleID.text);
                Navigator.pop(context);
              }
            : _authenticate,
        label: Text(_authorized ? "CONFIRM" : "AUTH NOW"),
        icon: Icon(_authorized ? Icons.check : Icons.security_outlined),
      ),
    );
  }
}

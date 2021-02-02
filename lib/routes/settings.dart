import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../utils.dart';
import '../widgets.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AwesomePopCard(
      context,
      headerChildren: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Settings",
              style: context.textTheme.headline4
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ],
      footerChildren: [
        ListTile(
          leading: Icon(Icons.data_usage),
          title: Text("Update Credentials"),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfigureCredentials()),
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
    try {
      setState(() {
        _authorized = false;
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to Update Credentials',
          useErrorDialogs: true,
          stickyAuth: true);
      if (!mounted) return;

      setState(() {
        _authorized = false;
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final message = authenticated ? true : false;
    setState(() {
      _authorized = message;
    });
  }

  bool _authorized = false;
  @override
  void initState() {
    _authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AwesomePopCard(
        context,
        headerChildren: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
          )
        ],
        footerChildren: !_authorized
            ? [
                Text(_authorized ? "Secure Hi" : "You are not authenticated."),
                FlatButton(
                  onPressed: _authenticate,
                  child: Text("Auth Now"),
                ),
              ]
            : [Text("Lets Go")],
      ),
    );
  }
}

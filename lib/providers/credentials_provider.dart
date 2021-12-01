import 'package:flutter/cupertino.dart';
import 'package:subillmanager/utils/shared_prefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final credentialsProvider = ChangeNotifierProvider<CredentialsNotifier>(
  (_) => CredentialsNotifier(),
);

class CredentialsNotifier extends ChangeNotifier {
  String _clientId = MyPrefs().prefs.getString("client_id") ?? "";
  String _spreadsheetId = MyPrefs().prefs.getString("spreadsheet_id") ?? "";

  String get clientId => _clientId;
  String get spreadsheetId => _spreadsheetId;

  set clientId(String newClientId) {
    _clientId = newClientId;
    MyPrefs().prefs.setString("client_id", clientId);
    notifyListeners();
  }

  set spreadsheetId(String newSpreadsheetId) {
    _spreadsheetId = newSpreadsheetId;
    MyPrefs().prefs.setString("spreadsheet_id", spreadsheetId);
    notifyListeners();
  }

  reset() {
    MyPrefs().prefs.remove("client_id").whenComplete(() => _clientId = "");
    MyPrefs()
        .prefs
        .remove("spreadsheet_id")
        .whenComplete(() => _spreadsheetId = "");
    notifyListeners();
  }
}

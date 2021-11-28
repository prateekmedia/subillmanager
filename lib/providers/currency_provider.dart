import 'package:subillmanager/utils/shared_prefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currencyProvider = StateNotifierProvider<CurrencyNotifier, int>(
  (_) => CurrencyNotifier(MyPrefs().prefs.getInt('currency') ?? 0),
);

class CurrencyNotifier extends StateNotifier<int> {
  CurrencyNotifier(state) : super(state);

  String get currency => ["₹", "\$"][state];

  set value(int newCurrency) {
    state = newCurrency;
    MyPrefs().prefs.setInt('currency', state);
  }

  reset() {
    MyPrefs().prefs.remove('currency').whenComplete(() => state = 0);
  }
}

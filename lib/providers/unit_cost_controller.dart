import 'package:subillmanager/utils/shared_prefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final unitCostProvider = StateNotifierProvider<UnitCostNotifier, double>(
  (_) => UnitCostNotifier(MyPrefs().prefs.getDouble('unit_cost') ?? 6.0),
);

class UnitCostNotifier extends StateNotifier<double> {
  UnitCostNotifier(state) : super(state);

  set value(double newCost) {
    state = newCost;
    MyPrefs().prefs.setDouble('unit_cost', state);
  }

  reset() {
    MyPrefs().prefs.remove('unit_cost').whenComplete(() => state = 6.0);
  }
}

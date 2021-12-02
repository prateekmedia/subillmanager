import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/utils/utils.dart';

enum CacheMode { dummy, cache, realtime }

final cacheModeProvider = StateNotifierProvider<CacheModeNotifier, CacheMode>(
  (_) => CacheModeNotifier(MyPrefs().prefs.getInt('cache_mode') ?? 0),
);

class CacheModeNotifier extends StateNotifier<CacheMode> {
  CacheModeNotifier(int state)
      : super(CacheMode.values.firstWhere((element) => element.index == state));

  set value(int newCacheMode) {
    state = newCacheMode.toCacheMode;
    MyPrefs().prefs.setInt('cache_mode', state.index);
  }

  reset() {
    MyPrefs()
        .prefs
        .remove('cache_mode')
        .whenComplete(() => state = CacheMode.dummy);
  }
}

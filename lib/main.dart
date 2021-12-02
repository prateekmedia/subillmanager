import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:subillmanager/homepage.dart';
import 'package:subillmanager/providers/providers.dart';
import 'package:subillmanager/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(
      Platform.isAndroid || Platform.isIOS || Platform.isMacOS
          ? (await getApplicationDocumentsDirectory()).path
          : (await getDownloadsDirectory())!
              .path
              .replaceFirst('Downloads', '.subillmanager'));
  await Hive.openBox('cache');

  // Initialize SharedPreferences
  await MyPrefs().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: const HomePage(),
      themeMode: ref.watch(themeTypeProvider),
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        colorScheme: const ColorScheme.dark().copyWith(
          surface: Colors.blue[400],
          primary: Colors.blue[200],
          secondary: Colors.blue[400],
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:subillmanager/home.dart';
import 'package:subillmanager/providers/providers.dart';
import 'package:subillmanager/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await MyPrefs().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: const Home(),
      themeMode: ref.watch(themeTypeProvider),
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

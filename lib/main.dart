import 'package:flutter/material.dart';
import 'package:popcorn/database_services/database_helper.dart';
import 'package:popcorn/pages/entry_category_page.dart';
import 'package:popcorn/pages/import_export_page.dart';
import 'package:popcorn/pages/settings_page.dart';
import 'package:popcorn/pages/watchlist_home_page.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initializeDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WatchlistEntryProvider()),
        ChangeNotifierProvider(create: (_) => EntryCategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popcorn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WatchlistHomePage(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const WatchlistHomePage(),
        '/entry-category': (context) => const EntryCategoryPage(),
        '/import-export': (context) => const ImportExportPage(),
        '/settings': (context) => const SettingsPage()
      },
    );
  }
}

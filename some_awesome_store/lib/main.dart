import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:some_awesome_store/managers/manager_network.dart';
import 'package:some_awesome_store/screens/screens_home.dart';
import 'package:sqflite/sqflite.dart';

late final database;
final networkManagerProvider = StateProvider((ref) => NetworkManager());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    setupDatabase();
    ref.read(networkManagerProvider);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: HomeScreen(),
        ),
      ),
    );
  }
}

void setupDatabase() async {
  database = await openDatabase(
    join(await getDatabasesPath(), 'cart_database.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE cart(id INTEGER PRIMARY KEY, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, amount INT)');
    },
    version: 1,
  );
}

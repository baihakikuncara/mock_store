import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/screens/screens_home.dart';
import 'package:sqflite/sqflite.dart';

final dio = Dio();
late final database;

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
      return db
          .execute('CREATE TABLE cart(id INTEGER PRIMARY KEY, amount INT)');
    },
    version: 1,
  );
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import 'package:treenotes/constants.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/note_page.dart';
import 'package:treenotes/notepage_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isAndroid) {
    // Initialize sqflite_ffi
    sqflite_ffi.sqfliteFfiInit();

    // Set the databaseFactory to use sqflite_ffi
    sqflite.databaseFactory = sqflite_ffi.databaseFactoryFfi;
  }

  // load the root node from the database
  final dbHelper = DatabaseHelper();
  // DELETE DATABASE
  // (await dbHelper.database)!.delete('Nodes', where: 'node_id >= 0');
  // (await dbHelper.database)!.delete('NodeRelationships', where: 'parent_id >= 0');
  // initialize the database
  await dbHelper.database;

  // Add root node if it does not exist
  if (await dbHelper.addRoot() == -1) {
    debugPrint('Root node already exists');
  } else {
    debugPrint('Root node added');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotePageProvider>(
      create: (context) => NotePageProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff12372A),
          ).copyWith(
            background: const Color(0xfffbfada),
            primary: const Color(0xff12372a),
            secondary: const Color(0xff436850),
            tertiary: const Color(0xffadbc9f),
          ),
          useMaterial3: true,
        ),
        home: const NotePage(nodeId: 0), // The root node has an id of 0
      ),
    );
  }
}

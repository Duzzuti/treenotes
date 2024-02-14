import 'package:flutter/material.dart';
import 'package:treenotes/node.dart';
import 'package:treenotes/note_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: load the root node from the database
    Node root = Node(null, 'Root title', 'Root content', 0, 0, []);
    root.add(title: 'Child 1 title', body: 'Child 1 content');
    root.add(title: 'mmmmmmmmmmmmmmmmmmmm', body: 'Child 2 content');
    root.children.add(Node(root, 'Child 3 title', 'Child 3 content', 9999, 9999, []));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tree Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff12372A)).copyWith(
          background: const Color(0xfffbfada),
          primary: const Color(0xff12372a),
          secondary: const Color(0xff436850),
          tertiary: const Color(0xffadbc9f),

        ),
        useMaterial3: true,
      ),
      home: NotePage(node: root),
    );
  }
}
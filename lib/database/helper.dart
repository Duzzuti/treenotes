import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;

    // If _database is null, initialize it
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    // Get the directory for the app's documents directory
    debugPrint('Initializing database');
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'treenotes.db');

    // Open/create the database at a given path
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the database tables
    debugPrint('Creating database tables');
    await db.execute('''
      CREATE TABLE Nodes (
        node_id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        num_children INTEGER,
        num_descendants INTEGER,
        parent_id INTEGER,
        FOREIGN KEY (parent_id) REFERENCES Nodes(node_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE NodeRelationships (
        parent_id INTEGER,
        child_id INTEGER,
        FOREIGN KEY (parent_id) REFERENCES Nodes(node_id),
        FOREIGN KEY (child_id) REFERENCES Nodes(node_id),
        PRIMARY KEY (parent_id, child_id)
      )
    ''');
  }

  Future<int> addRoot() async {
    final db = await database;
  
    // Check if there are any existing entries in the Nodes table
    final count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM Nodes'));

    if (count! > 0) {
      return -1; // The root node already exists
    }

    // If the Nodes table is empty, insert the root node
    return await db.insert('Nodes', 
      {
        'node_id': 0,
        'title': 'Main',
        'content': '',
        'num_children': 0,
        'num_descendants': 0,
        'parent_id': null,
      }
    );
  }

  Future<void> addNode({required int parentId, required String title, required String content}) async {
    final db = await database;
    final batch = db!.batch();

    // Increment num_descendants values of all parent nodes
    await _incrementDescendants(batch, parentId);

    // Increment num_children value of the direct parent node
    await _incrementChildren(batch, parentId);

    // Insert the new node
    final newNodeId = await db.insert('Nodes', {
      'title': title,
      'content': content,
      'num_children': 0,    // New nodes have no children initially
      'num_descendants': 0, // New nodes have no descendants initially
      'parent_id': parentId,
    });

    // Create a relationship between the new node and its parent node
    batch.insert('NodeRelationships', {
      'parent_id': parentId,
      'child_id': newNodeId,
    });

    // Execute the batch operations
    await batch.commit();
  }

  Future<void> deleteNode(int nodeId) async {
    final db = await database;
    final batch = db!.batch();

    // Decrement num_descendants values of all parent nodes
    final node = await getNodeById(nodeId);
    if (node != null) {
      final parentId = node['parent_id'] as int?;
      if (parentId != null) {
        await _subDescendants(batch, parentId, node['num_descendants'] + 1);
        await _decrementChildren(batch, parentId);
      } else {
        throw Exception('Parent node with ID $parentId not found. Cannot delete node $nodeId. Please note that the root node cannot be deleted.');
      }
    } else {
      throw Exception('Node with ID $nodeId not found');
    }
    await _deleteRecursively(batch, nodeId);
    // Execute the batch operations
    await batch.commit();
  }

  Future<void> _deleteRecursively(Batch batch, int nodeId) async {
    // Delete the node and its relationships recursively
    final children = await getChildren(parentId: nodeId);
    for (final child in children) {
      final childId = child['node_id'] as int;
      await _deleteRecursively(batch, childId);
    }
    batch.delete('Nodes', where: 'node_id = ?', whereArgs: [nodeId]);
    batch.delete('NodeRelationships', where: 'child_id = ?', whereArgs: [nodeId]);
  }

  Future<void> _subDescendants(Batch batch, int? parentId, int numDescendants) async {
    // Decrease num_descendants values of all parent nodes recursively
    if(parentId == null) return;
    final parent = await getNodeById(parentId);
    if (parent != null) {
      final int newNumDescendants = parent['num_descendants'] - numDescendants;
      if (newNumDescendants < 0) {
        throw Exception('Negative num_descendants value for node with ID $parentId');
      }
      batch.update('Nodes', {'num_descendants': newNumDescendants}, where: 'node_id = ?', whereArgs: [parentId]);
      await _subDescendants(batch, parent['parent_id'], numDescendants);
    } else {
      throw Exception('Parent node with ID $parentId not found');
    }
  }

  Future<void> _decrementChildren(Batch batch, int parentId) async {
    // Decrement num_children value of the direct parent node
    final parent = await getNodeById(parentId);
    if (parent != null) {
      final int numChildren = parent['num_children'] - 1;
      if (numChildren < 0) {
        throw Exception('Negative num_children value for node with ID $parentId');
      }
      batch.update('Nodes', {'num_children': numChildren}, where: 'node_id = ?', whereArgs: [parentId]);
    } else {
      throw Exception('Parent node with ID $parentId not found');
    }
  }

  Future<void> _incrementDescendants(Batch batch, int? parentId) async {
    // Increment num_descendants values of all parent nodes recursively
    if(parentId == null) return;
    final parent = await getNodeById(parentId);
    if (parent != null) {
      final int numDescendants = parent['num_descendants'] + 1;
      batch.update('Nodes', {'num_descendants': numDescendants}, where: 'node_id = ?', whereArgs: [parentId]);
      await _incrementDescendants(batch, parent['parent_id']);
    } else {
      throw Exception('Parent node with ID $parentId not found');
    }
  }

  Future<void> _incrementChildren(Batch batch, int parentId) async {
    // Increment num_children value of the direct parent node
    final parent = await getNodeById(parentId);
    if (parent != null) {
      final int numChildren = parent['num_children'] + 1;
      batch.update('Nodes', {'num_children': numChildren}, where: 'node_id = ?', whereArgs: [parentId]);
    } else {
      throw Exception('Parent node with ID $parentId not found');
    }
  }

  Future<Map<String, dynamic>?> getNodeById(int nodeId) async {
    final db = await database;
    final results = await db!.query('Nodes', where: 'node_id = ?', whereArgs: [nodeId]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getChildren({required int parentId}) async {
    final db = await database;
    final results = await db!.query(
      'NodeRelationships',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );

    final List<Map<String, dynamic>> children = [];
    for (final result in results) {
      final int childId = result['child_id'] as int;
      final childNode = await getNodeById(childId);
      if (childNode != null) {
        children.add(childNode);
      } else {
        throw Exception('Child node with ID $childId not found');
      }
    }
    return children;
  }
}

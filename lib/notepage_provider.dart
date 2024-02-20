import 'package:flutter/material.dart';
import 'package:treenotes/note_page.dart';

class NotePageProvider extends ChangeNotifier {
  NotePageMode _mode = NotePageMode.normal;
  List<int> _selectedNodes = [];
  int _selectedDescendants = 0;

  // Getter for accessing the value
  NotePageMode get mode => _mode;
  List<int> get selectedNodes => _selectedNodes;
  int get selectedDescendants => _selectedDescendants;

  // Method for updating the value
  void set(NotePageMode newMode) {
    if (newMode == NotePageMode.normal) {
      _selectedNodes = [];
      _selectedDescendants = 0;
    }
    _mode = newMode;
    // Notify listeners to update widgets that depend on this provider
    notifyListeners();
  }

  void Function()? selectedNodeChanges(int nodeId, int descendants) {
    switch (_mode) {
      case NotePageMode.normal:
        return null;
      case NotePageMode.selection:
        return () {
          if (!_selectedNodes.contains(nodeId)) {
            _selectedNodes.add(nodeId);
            _selectedDescendants += descendants;
          } else {
            _selectedNodes.remove(nodeId);
            _selectedDescendants -= descendants;
          }
          notifyListeners();
        };
      case NotePageMode.move:
        // TODO: Implement move mode
        return () => {};
    }
  }
}

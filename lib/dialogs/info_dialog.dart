import 'package:flutter/material.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/dialogs/edit_dialog.dart';

class InfoDialog extends StatefulWidget {
  final Map<String, dynamic> node;
  const InfoDialog({super.key, required this.node});

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.node["title"], style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 24)),
            const SizedBox(height: 16),
            Text(widget.node["content"], style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(bottom: 12, left: 12, right: 12)),
                  ),
                  child: Text('Cancel', 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => EditDialog(node: widget.node)).then((value) => Navigator.pop(context));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(bottom: 12, left: 12, right: 12)),
                  ),
                  child: Text('Edit', 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final dbHelper = DatabaseHelper();
                    dbHelper.deleteNode(widget.node['node_id']).then((value) => Navigator.pop(context));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(bottom: 12, left: 12, right: 12)),
                  ),
                  child: Text('Delete', 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
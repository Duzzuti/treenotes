import 'package:flutter/material.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/dialogs/confirmation_dialog.dart';
import 'package:treenotes/dialogs/edit_dialog.dart';
import 'package:treenotes/widgets/dialog_button.dart';

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
            Text(
              widget.node["title"],
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.node["content"],
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CancelDialogButton(),
                DialogButton(
                  context: context,
                  text: "Edit",
                  onPressed: () => showDialog(
                          context: context,
                          builder: (context) => EditDialog(node: widget.node))
                      .then((value) => Navigator.pop(context)),
                ),
                DialogButton(
                  context: context,
                  text: "Delete",
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      title: 'Delete Node',
                      content:
                          'Are you sure you want to delete this node AND ALL ${widget.node["num_descendants"]} DESCENDANTS?',
                      requiredDelay: 3000,
                      onConfirm: () {
                        final dbHelper = DatabaseHelper();
                        dbHelper
                            .deleteNode(widget.node['node_id'])
                            .then((value) => Navigator.pop(context));
                      },
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

import 'package:flutter/material.dart';
import 'package:treenotes/constants.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/dialogs/confirmation_dialog.dart';
import 'package:treenotes/dialogs/edit_dialog.dart';
import 'package:treenotes/widgets/dialog_button.dart';
import 'package:treenotes/widgets/scrollable_text.dart';

class InfoDialog extends StatefulWidget {
  final Map<String, dynamic> node;
  const InfoDialog({super.key, required this.node});

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    var divider = Divider(
      color: Theme.of(context).colorScheme.primary,
      thickness: 1,
    );
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: Constants.infoHeaderFlex,
              child: ScrollableText(
                text: widget.node["title"],
                fontSize: Constants.fontSizeBig,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 2,
            ),
            const SizedBox(height: 16),
            divider,
            Expanded(
              flex: Constants.infoContentFlex,
              child: ScrollableText(
                text: widget.node["content"],
                fontSize: Constants.fontSizeMedium,
              ),
            ),
            divider,
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
                          'Are you sure you want to DELETE THIS NODE AND ALL ${widget.node["num_descendants"]} DESCENDANTS?',
                      requiredDelay: Constants.confirmationSingleDeleteDelay,
                      onConfirm: () {
                        final dbHelper = DatabaseHelper();
                        _isDeleting = true;
                        dbHelper
                            .deleteNode(widget.node['node_id'])
                            .then((value) => Navigator.pop(context));
                      },
                    ),
                  ).then((value) {
                    _isDeleting ? _isDeleting = false : Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

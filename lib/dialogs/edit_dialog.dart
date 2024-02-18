import 'package:flutter/material.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/dialogs/confirmation_dialog.dart';
import 'package:treenotes/widgets/dialog_button.dart';
import 'package:treenotes/widgets/node_input_dialog.dart';

class EditDialog extends StatefulWidget {
  final Map<String, dynamic> node;
  const EditDialog({super.key, required this.node});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ScrollController contentScrollController = ScrollController();
  bool submitActivated = true;

  @override
  void initState() {
    titleController.text = widget.node['title'];
    contentController.text = widget.node['content'];
    titleController.addListener(() {
      setState(() {
        submitActivated = titleController.text.isNotEmpty &&
            contentController.text.isNotEmpty;
      });
    });
    contentController.addListener(() {
      setState(() {
        submitActivated = titleController.text.isNotEmpty &&
            contentController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NodeInputDialog(
      title: 'Edit Node',
      titleController: titleController,
      contentScrollController: contentScrollController,
      contentController: contentController,
      confirmDialog: DialogButton(
        context: context,
        text: "Confirm",
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: 'Edit Node',
            content: 'Are you sure you want to save the changes?',
            requiredDelay: 1000,
            onConfirm: () async {
              // Update the node in the database
              // (see the next snippet for the implementation of the DatabaseHelper class)
              final dbHelper = DatabaseHelper();
              await dbHelper
                  .updateNode(widget.node["node_id"], titleController.text,
                      contentController.text)
                  .then((value) => Navigator.pop(context));
            },
          ),
        ),
        submitActivated: submitActivated,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/widgets/dialog_button.dart';
import 'package:treenotes/widgets/node_input_dialog.dart';

class CreateDialog extends StatefulWidget {
  final int parentId;
  const CreateDialog({super.key, required this.parentId});

  @override
  State<CreateDialog> createState() => _CreateDialogState();
}

class _CreateDialogState extends State<CreateDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ScrollController contentScrollController = ScrollController();
  bool submitActivated = false;

  @override
  void initState() {
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
      title: 'New Note',
      titleController: titleController,
      contentScrollController: contentScrollController,
      contentController: contentController,
      confirmDialog: DialogButton(
        context: context,
        text: "Create Note",
        onPressed: () {
          final dbHelper = DatabaseHelper();
          dbHelper
              .addNode(
                  parentId: widget.parentId,
                  title: titleController.text,
                  content: contentController.text)
              .then((value) => Navigator.pop(context));
        },
        submitActivated: submitActivated,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:treenotes/widgets/content_inputfield.dart';
import 'package:treenotes/widgets/dialog_button.dart';
import 'package:treenotes/widgets/title_inputfield.dart';

class NodeInputDialog extends StatelessWidget {
  const NodeInputDialog({
    super.key,
    required this.title,
    required this.titleController,
    required this.contentScrollController,
    required this.contentController,
    required this.confirmDialog,
  });

  final String title;
  final TextEditingController titleController;
  final ScrollController contentScrollController;
  final TextEditingController contentController;
  final DialogButton confirmDialog;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 24)),
              const SizedBox(height: 16),
              TitleInputField(titleController: titleController),
              const SizedBox(height: 16),
              ContentInputField(contentScrollController: contentScrollController, contentController: contentController),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CancelDialogButton(),
                  confirmDialog,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:treenotes/database/helper.dart';

class EditDialog extends StatefulWidget {
  final Map<String, dynamic> node;
  const EditDialog({super.key, required this.node});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  bool submitActivated = true;

  @override
  void initState() {
    titleController.text = widget.node['title'];
    contentController.text = widget.node['content'];
    titleController.addListener(() { setState(() {
      submitActivated = titleController.text.isNotEmpty && contentController.text.isNotEmpty;
    }); });
    contentController.addListener(() { setState(() {
      submitActivated = titleController.text.isNotEmpty && contentController.text.isNotEmpty;
    }); });
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
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit Node', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 24)),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 320,
              child: TextField(
                controller: contentController,
                maxLines: null,
                minLines: 12,
                scrollPhysics: const AlwaysScrollableScrollPhysics(),
                decoration: InputDecoration(
                  hintText: 'Content',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ),
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
                  onPressed: !submitActivated ? null : () async {
                    final dbHelper = DatabaseHelper();
                    await dbHelper.updateNode(widget.node["node_id"], titleController.text, contentController.text).then((value) => Navigator.pop(context));
                  },
                  style: ButtonStyle(
                    backgroundColor: submitActivated 
                      ? MaterialStateProperty.all(Theme.of(context).colorScheme.secondary) 
                      : MaterialStateProperty.all(Theme.of(context).colorScheme.tertiary),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(bottom: 12, left: 12, right: 12)),
                  ),
                  child: Text('Confirm', 
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
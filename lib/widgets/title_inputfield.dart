import 'package:flutter/material.dart';

class TitleInputField extends StatelessWidget {
  const TitleInputField({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Title',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}


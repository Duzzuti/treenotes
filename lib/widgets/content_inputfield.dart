import 'package:flutter/material.dart';
import 'package:treenotes/constants.dart';

class ContentInputField extends StatelessWidget {
  const ContentInputField({
    super.key,
    required this.contentScrollController,
    required this.contentController,
  });

  final ScrollController contentScrollController;
  final TextEditingController contentController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Constants.contentInputFieldHeight,
      child: Scrollbar(
        trackVisibility: true,
        thumbVisibility: true,
        radius: const Radius.circular(8),
        interactive: true,
        controller: contentScrollController,
        thickness: 16,
        child: SingleChildScrollView(
          controller: contentScrollController,
          scrollDirection: Axis.vertical,
          child: TextField(
            autofocus: true,
            controller: contentController,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
            minLines: Constants.contentMinLines,
            decoration: InputDecoration(
              hintText: 'Content',
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

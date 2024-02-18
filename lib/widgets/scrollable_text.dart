import 'package:flutter/material.dart';

class ScrollableText extends StatelessWidget {
  final String text;
  final double fontSize;
  const ScrollableText({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController contentScrollController = ScrollController();
    return Row(
      children: [
        Expanded(
          child: Scrollbar(
            trackVisibility: true,
            thumbVisibility: true,
            radius: const Radius.circular(8),
            interactive: true,
            controller: contentScrollController,
            thickness: 12,
            child: SingleChildScrollView(
              controller: contentScrollController,
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

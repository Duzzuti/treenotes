import 'package:flutter/material.dart';
import 'package:treenotes/constants.dart';

class InfoHeader extends StatelessWidget {
  const InfoHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        SizedBox(
          width: MediaQuery.of(context).size.width * Constants.headerNoteWidthFraction,
          child: Text(
            'Note',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: Constants.fontSizeMedium,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * Constants.headerChildrenWidthFraction,
          child: Center(
            child: Text(
              'direct/indirect children',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Constants.fontSizeMedium,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * Constants.headerGoWidthFraction,
          child: Center(
            child: Text(
              'Go',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Constants.fontSizeMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

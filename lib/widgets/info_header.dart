import 'package:flutter/material.dart';

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
          width: MediaQuery.of(context).size.width * 0.135,
          child: Text(
            'Note',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.64,
          child: Center(
            child: Text(
              'direct/indirect children',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.08,
          child: Center(
            child: Text(
              'Go',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

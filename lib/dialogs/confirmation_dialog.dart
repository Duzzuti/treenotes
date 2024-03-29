import 'dart:async';

import 'package:flutter/material.dart';
import 'package:treenotes/constants.dart';
import 'package:treenotes/widgets/dialog_button.dart';

class ConfirmationDialog extends StatefulWidget {
  final String title;
  final String content;
  final int requiredDelay;
  final Function onConfirm;

  const ConfirmationDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.requiredDelay,
      required this.onConfirm});

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  DateTime? pressStarted;
  double progress = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Constants.confirmationUpdateInterval, (timer) {
      setState(() {
        if (pressStarted != null) {
          progress = DateTime.now().difference(pressStarted!).inMilliseconds /
              widget.requiredDelay;
          if (progress >= 1) {
            progress = 1;
            widget.onConfirm();
            Navigator.pop(context);
          }
        } else {
          progress = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
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
            Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Constants.fontSizeHuge,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.content,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Constants.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CancelDialogButton(),
                InkWell(
                  customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  onTapDown: (_) {
                    setState(() {
                      pressStarted = DateTime.now();
                    });
                  },
                  onTapUp: (_) {
                    if (pressStarted != null &&
                        DateTime.now().difference(pressStarted!) >=
                            Duration(milliseconds: widget.requiredDelay)) {
                      widget.onConfirm();
                      Navigator.pop(context);
                    }
                    setState(() {
                      pressStarted = null;
                    });
                  },
                  onHighlightChanged: (highlighted) {
                    if (!highlighted) {
                      setState(() {
                        pressStarted = null;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red,
                          pressStarted != null
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.secondary,
                        ],
                        stops: [(progress - Constants.progressFade), progress],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(8),
                        ),
                        mouseCursor:
                            MaterialStateProperty.all(SystemMouseCursors.click),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: Constants.fontSizeMedium,
                        ),
                      ),
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

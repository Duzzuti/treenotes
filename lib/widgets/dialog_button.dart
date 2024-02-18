import 'package:flutter/material.dart';

class DialogButton extends ElevatedButton {
  final bool submitActivated;
  DialogButton(
      {super.key,
      required BuildContext context,
      required String text,
      required void Function() onPressed,
      this.submitActivated = true})
      : super(
          onPressed: submitActivated ? onPressed : null,
          style: ButtonStyle(
            backgroundColor: submitActivated
                ? MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary)
                : MaterialStateProperty.all(
                    Theme.of(context).colorScheme.tertiary),
            padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 20,
            ),
          ),
        );
}

class CancelDialogButton extends StatelessWidget {
  const CancelDialogButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DialogButton(
      context: context,
      text: "Cancel",
      onPressed: () => Navigator.pop(context),
    );
  }
}

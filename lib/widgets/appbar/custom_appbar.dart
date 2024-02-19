import 'package:flutter/material.dart';
import 'package:treenotes/constants.dart';

class ActionData {
  final IconData icon;
  final void Function() onPressed;
  final bool enabled;
  const ActionData(
      {required this.icon, required this.onPressed, this.enabled = true});
}

class ActionDataList {
  final List<ActionData> actions;
  const ActionDataList({required this.actions});

  List<Widget> getList(BuildContext context) {
    List<IconButton> list = [];
    for (var action in actions) {
      list.add(
        IconButton(
          padding: const EdgeInsets.all(8),
          icon: Icon(
            action.icon,
            color: action.enabled
                ? Theme.of(context).colorScheme.background
                : Theme.of(context)
                    .colorScheme
                    .background
                    .withOpacity(Constants.fadeOpacity),
            size: Constants.iconSizeHuge,
          ),
          onPressed: action.enabled ? action.onPressed : null,
        ),
      );
    }
    return list;
  }
}

class CustomAppBar extends AppBar {
  final bool standardColor;
  CustomAppBar(
      {super.key,
      required context,
      this.standardColor = true,
      required String title,
      required ActionDataList actions})
      : super(
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          toolbarHeight: 64,
          actions: actions.getList(context),
          backgroundColor: standardColor
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.primary,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.background,
          ),
        );
}

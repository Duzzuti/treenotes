import 'package:flutter/material.dart';

class ActionData {
  final IconData icon;
  final Function onPressed;
  const ActionData({required this.icon, required this.onPressed});
}

class ActionDataList {
  final List<ActionData> actions;
  const ActionDataList({required this.actions});

  List<Widget> getList(BuildContext context) {
    List<IconButton> list = [];
    int i = 0;
    for (var action in actions) {
      i++;
      list.add(
        IconButton(
          padding: i > actions.length
              ? const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8)
              : const EdgeInsets.all(8),
          icon: Icon(
            action.icon,
            color: Theme.of(context).colorScheme.background,
            size: 48,
          ),
          onPressed: () {
            action.onPressed();
          },
        ),
      );
    }
    return list;
  }
}

class CustomAppBar extends AppBar {
  CustomAppBar(
      {super.key,
      required context,
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
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.background,
          ),
        );
}

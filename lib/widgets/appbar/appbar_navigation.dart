import 'package:flutter/material.dart';
import 'package:treenotes/widgets/appbar/custom_appbar.dart';

class NavigationAppBar extends CustomAppBar {
  NavigationAppBar({
    super.key,
    required BuildContext super.context,
    required bool isLoading,
    required Map<String, dynamic>? node,
    required void Function() leaveNavigationMode,
  }) : super(
          title: isLoading ? "Loading..." : node!["title"],
          color: Theme.of(context).colorScheme.tertiary,
          actions: ActionDataList(
            actions: [
              ActionData(
                icon: Icons.cancel,
                onPressed: leaveNavigationMode,
              ),
              ActionData(
                icon: Icons.move_to_inbox,
                onPressed: () {
                  // TODO: Implement move
                },
              ),
              ActionData(
                icon: Icons.home,
                onPressed: () {
                  // TODO: Implement move to root
                },
              ),
            ],
          ),
        );
}

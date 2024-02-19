import 'package:flutter/material.dart';
import 'package:treenotes/widgets/appbar/custom_appbar.dart';

class SelectionAppBar extends CustomAppBar {
  SelectionAppBar({
    super.key,
    required BuildContext super.context,
    required bool isLoading,
    required bool isSelected,
    required int nodeId,
    required Map<String, dynamic>? node,
    required void Function() loadData,
    required void Function() leaveSelectionMode,
  }) : super(
          standardColor: false,
          title: isLoading ? "Loading..." : node!["title"],
          actions: ActionDataList(
            actions: [
              ActionData(
                icon: Icons.check_box_outlined,
                onPressed: leaveSelectionMode,
              ),
              ActionData(
                icon: Icons.drive_file_move,
                enabled: isSelected,
                onPressed: () {
                  // TODO: Implement move
                },
              ),
              ActionData(
                icon: Icons.delete,
                enabled: isSelected,
                onPressed: () {
                  // TODO: Implement delete
                },
              ),
            ],
          ),
        );
}

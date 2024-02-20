import 'package:flutter/material.dart';
import 'package:treenotes/constants.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/dialogs/confirmation_dialog.dart';
import 'package:treenotes/widgets/appbar/custom_appbar.dart';

class SelectionAppBar extends CustomAppBar {
  SelectionAppBar({
    super.key,
    required BuildContext super.context,
    required bool isLoading,
    required List<int> selectedNodes,
    required int selectedDescendants,
    required int nodeId,
    required Map<String, dynamic>? node,
    required void Function() loadData,
    required void Function() leaveSelectionMode,
  }) : super(
          color: Theme.of(context).colorScheme.primary,
          title: isLoading ? "Loading..." : node!["title"],
          actions: ActionDataList(
            actions: [
              ActionData(
                icon: Icons.check_box_outlined,
                onPressed: leaveSelectionMode,
              ),
              ActionData(
                icon: Icons.drive_file_move,
                enabled: selectedNodes.isNotEmpty,
                onPressed: () {
                  // TODO: Implement move
                },
              ),
              ActionData(
                icon: Icons.delete,
                enabled: selectedNodes.isNotEmpty,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      title: 'Delete Nodes',
                      content:
                          'Are you sure you want to DELETE ALL ${selectedNodes.length} SELECTED NODES AND ALL $selectedDescendants DESCENDANTS?',
                      requiredDelay: Constants.confirmationMultipleDeleteDelay,
                      onConfirm: () async {
                        final dbHelper = DatabaseHelper();
                        await dbHelper.deleteNodes(selectedNodes);
                        loadData();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
}

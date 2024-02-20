import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treenotes/constants.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/dialogs/confirmation_dialog.dart';
import 'package:treenotes/note_page.dart';
import 'package:treenotes/notepage_provider.dart';
import 'package:treenotes/widgets/appbar/custom_appbar.dart';

class SelectionAppBar extends CustomAppBar {
  SelectionAppBar({
    super.key,
    required BuildContext super.context,
    required bool isLoading,
    required int nodeId,
    required Map<String, dynamic>? node,
    required void Function() loadData,
  }) : super(
          color: Theme.of(context).colorScheme.primary,
          title: isLoading ? "Loading..." : node!["title"],
          actions: ActionDataList(
            actions: [
              ActionData(
                icon: Icons.check_box_outlined,
                onPressed: () =>
                    Provider.of<NotePageProvider>(context, listen: false)
                        .set(NotePageMode.normal),
              ),
              ActionData(
                icon: Icons.drive_file_move,
                enabled: Provider.of<NotePageProvider>(context)
                    .selectedNodes
                    .isNotEmpty,
                onPressed: () =>
                    Provider<NotePageMode>.value(value: NotePageMode.move),
              ),
              ActionData(
                icon: Icons.delete,
                enabled: Provider.of<NotePageProvider>(context)
                    .selectedNodes
                    .isNotEmpty,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      title: 'Delete Nodes',
                      content:
                          'Are you sure you want to DELETE ALL ${Provider.of<NotePageProvider>(context).selectedNodes.length} SELECTED NODES AND ALL ${Provider.of<NotePageProvider>(context).selectedDescendants} DESCENDANTS?',
                      requiredDelay: Constants.confirmationMultipleDeleteDelay,
                      onConfirm: () async {
                        final dbHelper = DatabaseHelper();
                        await dbHelper.deleteNodes(
                            Provider.of<NotePageProvider>(context,
                                    listen: false)
                                .selectedNodes);
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

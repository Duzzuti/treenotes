import 'package:flutter/material.dart';
import 'package:treenotes/dialogs/create_dialog.dart';
import 'package:treenotes/widgets/appbar/custom_appbar.dart';

class NormalAppBar extends CustomAppBar {
  NormalAppBar({
    super.key,
    required BuildContext super.context,
    required bool isLoading,
    required int nodeId,
    required Map<String, dynamic>? node,
    required void Function() loadData,
    required void Function() enterSelectionMode,
  }) : super(
          title: isLoading ? "Loading..." : node!["title"],
          actions: ActionDataList(
            actions: [
              ActionData(
                icon: Icons.check_box_outline_blank_outlined,
                onPressed: enterSelectionMode,
              ),
              ActionData(
                icon: Icons.add,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => isLoading
                        ? const Dialog()
                        : CreateDialog(parentId: nodeId),
                    barrierDismissible: false,
                  ).then((value) => loadData());
                },
              ),
              ActionData(
                icon: Icons.home,
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/'),
                  );
                },
              ),
            ],
          ),
        );
}

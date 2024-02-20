import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treenotes/dialogs/create_dialog.dart';
import 'package:treenotes/note_page.dart';
import 'package:treenotes/notepage_provider.dart';
import 'package:treenotes/widgets/appbar/custom_appbar.dart';

class NormalAppBar extends CustomAppBar {
  NormalAppBar({
    super.key,
    required BuildContext super.context,
    required bool isLoading,
    required int nodeId,
    required Map<String, dynamic>? node,
    required void Function() loadData,
  }) : super(
          title: isLoading ? "Loading..." : node!["title"],
          actions: ActionDataList(
            actions: [
              ActionData(
                icon: Icons.check_box_outline_blank_outlined,
                onPressed: () =>
                    Provider.of<NotePageProvider>(context, listen: false)
                        .set(NotePageMode.selection),
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

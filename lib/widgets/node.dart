import 'package:flutter/material.dart';
import 'package:treenotes/constants.dart';
import 'package:treenotes/dialogs/info_dialog.dart';
import 'package:treenotes/note_page.dart';

class Node extends StatelessWidget {
  final bool selectionMode;
  final bool selected;
  final int index;
  final List<Map<String, dynamic>>? children;
  final void Function() loadData;
  final void Function() onSelectionChanged;

  const Node({
    super.key,
    required this.selectionMode,
    required this.index,
    required this.children,
    required this.loadData,
    required this.onSelectionChanged,
    this.selected = false,
  });

  Color _getColor(BuildContext context) {
    if (selected) {
      return Theme.of(context).colorScheme.onPrimary;
    } else {
      if (selectionMode) {
        return Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(Constants.fadeOpacity);
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.primary,
      onTap: !selectionMode ? null : onSelectionChanged,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.tertiary,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  Constants.nodeTitleWidthFraction,
              child: TextButton(
                onPressed: selectionMode
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => InfoDialog(
                            node: children![index],
                          ),
                        ).then((value) => loadData());
                      },
                child: Text(
                  children![index]["title"],
                  style: TextStyle(
                    color: _getColor(context),
                    fontSize: Constants.fontSizeMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  Constants.nodeChildrenWidthFraction,
              child: Center(
                child: Text(
                  children![index]["num_children"] > 999
                      ? '>999'
                      : children![index]["num_children"].toString(),
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    color: _getColor(context),
                    fontSize: Constants.fontSizeSmall,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  Constants.nodeChildrenWidthFraction,
              child: Center(
                child: Text(
                  children![index]["num_descendants"] > 999
                      ? '>999'
                      : children![index]["num_descendants"].toString(),
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    color: _getColor(context),
                    fontSize: Constants.fontSizeSmall,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: selectionMode
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotePage(
                            nodeId: children![index]["node_id"],
                          ),
                        ),
                      ).then((value) => loadData());
                    },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: _getColor(context),
                size: Constants.iconSizeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

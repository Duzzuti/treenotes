import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treenotes/constants.dart';
import 'package:treenotes/dialogs/info_dialog.dart';
import 'package:treenotes/note_page.dart';
import 'package:treenotes/notepage_provider.dart';

class Node extends StatelessWidget {
  final int index;
  final List<Map<String, dynamic>>? children;
  final void Function() loadData;

  const Node({
    super.key,
    required this.index,
    required this.children,
    required this.loadData,
  });

  Color _getColor(BuildContext context, bool selected) {
    if (selected) {
      return Theme.of(context).colorScheme.onPrimary;
    } else {
      if (Provider.of<NotePageProvider>(context).mode ==
          NotePageMode.selection) {
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
    bool selected = Provider.of<NotePageProvider>(context)
        .selectedNodes
        .contains(children![index]["node_id"]);
    return InkWell(
      splashColor: Theme.of(context).colorScheme.primary,
      onTap: Provider.of<NotePageProvider>(context).selectedNodeChanges(
        children![index]["node_id"],
        children![index]["num_descendants"] as int,
      ),
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
                onPressed: Provider.of<NotePageProvider>(context).mode !=
                        NotePageMode.normal
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
                    color: _getColor(context, selected),
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
                    color: _getColor(context, selected),
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
                    color: _getColor(context, selected),
                    fontSize: Constants.fontSizeSmall,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: Provider.of<NotePageProvider>(context).mode !=
                      NotePageMode.normal
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotePage(
                            nodeId: children![index]["node_id"],
                          ),
                        ),
                      ).then((value) {
                        if (Provider.of<NotePageProvider>(context,
                                    listen: false)
                                .mode ==
                            NotePageMode.selection) {
                          Provider.of<NotePageProvider>(context, listen: false)
                              .set(NotePageMode.normal);
                        }
                        loadData();
                      });
                    },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: _getColor(context, selected),
                size: Constants.iconSizeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

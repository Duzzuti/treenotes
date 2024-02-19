import 'package:flutter/material.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/widgets/appbar/appbar_normal.dart';
import 'package:treenotes/widgets/appbar/appbar_selection.dart';
import 'package:treenotes/widgets/info_header.dart';
import 'package:treenotes/widgets/loading_scaffold.dart';
import 'package:treenotes/widgets/node.dart';

class NotePage extends StatefulWidget {
  final int nodeId;
  const NotePage({super.key, required this.nodeId});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final dbHelper = DatabaseHelper();
  bool isLoading = true;
  bool selectionMode = false;
  Map<String, dynamic>? node;
  List<Map<String, dynamic>>? children;
  List<int> selectedNodes = [];

  void loadData() {
    isLoading = true;
    // load the node from the database
    dbHelper.getNodeById(widget.nodeId).then((node) {
      setState(() {
        debugPrint('Got node: ${widget.nodeId}');
        this.node = node;
        isLoading = (children == null);
        debugPrint("Node is: $node");
      });
    });
    // Retrieve the children of the node
    dbHelper.getChildren(parentId: widget.nodeId).then((children) {
      setState(() {
        debugPrint('Got children from node: ${widget.nodeId}');
        this.children = children;
        isLoading = (node == null);
        debugPrint("Children are: $children");
      });
    });
  }

  @override
  void initState() {
    // load the node from the database
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return LoadingScaffold(
          appBar: selectionMode
              ? SelectionAppBar(
                  context: context,
                  isLoading: isLoading,
                  isSelected: selectedNodes.isNotEmpty,
                  nodeId: widget.nodeId,
                  node: node,
                  loadData: loadData,
                  leaveSelectionMode: () {
                    setState(() {
                      selectionMode = false;
                      selectedNodes.clear();
                    });
                  },
                )
              : NormalAppBar(
                  context: context,
                  isLoading: isLoading,
                  nodeId: widget.nodeId,
                  node: node,
                  loadData: loadData,
                  enterSelectionMode: () {
                    setState(() {
                      selectionMode = true;
                      selectedNodes.clear();
                    });
                  },
                ),
          body: Column(
            children: [
              const InfoHeader(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Node(
                      selectionMode: selectionMode,
                      index: index,
                      children: children,
                      loadData: loadData,
                      selected: selectedNodes.contains(
                        children![index]["node_id"],
                      ),
                      onSelectionChanged: () {
                        setState(() {
                          if (selectedNodes
                              .contains(children![index]["node_id"])) {
                            selectedNodes.remove(children![index]["node_id"]);
                          } else {
                            selectedNodes.add(children![index]["node_id"]);
                          }
                        });
                      },
                    );
                  },
                  itemCount: children == null ? 0 : children!.length,
                ),
              ),
            ],
          ),
          isLoading: isLoading,
        );
      },
    );
  }
}

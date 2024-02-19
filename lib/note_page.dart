import 'package:flutter/material.dart';
import 'package:treenotes/constants.dart';
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
  int selectedDescendants = 0;

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
                  selectedNodes: selectedNodes,
                  selectedDescendants: selectedDescendants,
                  nodeId: widget.nodeId,
                  node: node,
                  loadData: loadData,
                  leaveSelectionMode: () {
                    setState(() {
                      selectionMode = false;
                      selectedNodes.clear();
                      selectedDescendants = 0;
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
                      selectedDescendants = 0;
                    });
                  },
                ),
          body: Column(
            children: [
              const InfoHeader(),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    Constants.nodesListHeightFraction,
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
                            selectedDescendants -=
                                children![index]["num_descendants"] as int;
                          } else {
                            selectedNodes.add(children![index]["node_id"]);
                            selectedDescendants +=
                                children![index]["num_descendants"] as int;
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

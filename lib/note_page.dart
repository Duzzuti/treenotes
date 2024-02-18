import 'package:flutter/material.dart';
import 'package:treenotes/dialogs/create_dialog.dart';
import 'package:treenotes/database/helper.dart';
import 'package:treenotes/dialogs/info_dialog.dart';
import 'package:treenotes/widgets/custom_appbar.dart';
import 'package:treenotes/widgets/info_header.dart';
import 'package:treenotes/widgets/loading_scaffold.dart';

class NotePage extends StatefulWidget {
  final int nodeId;
  const NotePage({super.key, required this.nodeId});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final dbHelper = DatabaseHelper();
  bool isLoading = true;
  Map<String, dynamic>? node;
  List<Map<String, dynamic>>? children;

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
          appBar: CustomAppBar(
            context: context,
            title: isLoading ? "Loading..." : node!["title"],
            actions: ActionDataList(
              actions: [
                ActionData(
                  icon: Icons.add,
                  onPressed: () {
                    showDialog(
                            context: context,
                            builder: (context) => isLoading
                                ? const Dialog()
                                : CreateDialog(parentId: widget.nodeId),
                            barrierDismissible: false)
                        .then((value) => loadData());
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
                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                        context: context,
                                        builder: (context) =>
                                            InfoDialog(node: children![index]))
                                    .then((value) => loadData());
                              },
                              child: Text(
                                children![index]["title"],
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Center(
                              child: Text(
                                children![index]["num_children"] > 999
                                    ? '>999'
                                    : children![index]["num_children"]
                                        .toString(),
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Center(
                              child: Text(
                                children![index]["num_descendants"] > 999
                                    ? '>999'
                                    : children![index]["num_descendants"]
                                        .toString(),
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Center(
                            child: InkWell(
                              hoverColor: Colors.red,
                              focusColor: Colors.red,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.red),
                              highlightColor: Colors.red,
                              splashColor: Colors.red,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotePage(
                                            nodeId: children![index]["node_id"],
                                          )),
                                ).then((value) => loadData());
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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

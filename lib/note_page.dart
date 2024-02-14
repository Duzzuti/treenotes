import 'package:flutter/material.dart';
import 'package:treenotes/create_dialog.dart';
import 'package:treenotes/node.dart';

class NotePage extends StatelessWidget {
  final Node node;
  const NotePage({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.background),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(node.subject, style: TextStyle(color: Theme.of(context).colorScheme.background)),
          actions: [
            IconButton(
              icon: Icon(Icons.add,
                color: Theme.of(context).colorScheme.background,
                size: 48,
              ),
              onPressed: () {
                showDialog(context: context, builder: (context) => CreateDialog(parent: node));
              },
            ),
            IconButton(
              icon: Icon(Icons.home,
                color: Theme.of(context).colorScheme.background,
                size: 48,
              ),
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/'),
                );
              },
            ),
      
          ],
        ),
        body: Column(
          children:[ 
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
                          child: Text(node.children[index].subject,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Center(
                            child: Text(node.children[index].numChilds > 999 ? '>999' : node.children[index].numChilds.toString(),
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
                            child: Text(node.children[index].numChilds > 999 ? '>999' : node.children[index].numChilds.toString(),
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
                            overlayColor: MaterialStateProperty.all(Colors.red),
                            highlightColor: Colors.red,
                            splashColor: Colors.red,
                                
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NotePage(node: node.children[index])),
                              );
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Icon(Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  );
                },
                itemCount: node.children.length,
              ),
            ),
          ],
        ),
      );
      }
    );
  }
}
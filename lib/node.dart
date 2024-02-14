class Node {
  String subject;
  String body;
  int numChilds;
  int numChildsRec;
  Node? parent;
  List<Node> children;

  Node(this.parent, this.subject, this.body, this.numChilds, this.numChildsRec, this.children);

  void add({required String title, required String body}) {
    children.add(Node(this, title, body, 0, 0, []));
    numChilds++;
    numChildsRec++;
    Node? parentNode = parent;
    while (parentNode != null) {
      parent!.numChildsRec++;
      parent = parent!.parent;
    }

  }
}
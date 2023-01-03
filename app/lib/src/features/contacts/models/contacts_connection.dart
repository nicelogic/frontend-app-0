import 'package:equatable/equatable.dart';
import 'package:contacts_repository/contacts_repository.dart'
    as contacts_repository;

class PageInfo extends Equatable {
  final String endCursor;
  final bool hasNextPage;

  const PageInfo(this.endCursor, this.hasNextPage);
  PageInfo.fromContactsPageInfo(contacts_repository.ContactsPageInfo pageInfo)
      : this(pageInfo.endCursor, pageInfo.hasNextPage);

  @override
  List<Object?> get props => [endCursor, hasNextPage];
}

class Node extends Equatable {
  final String id;
  final String remarkName;

  const Node(this.id, this.remarkName);
  Node.fromContactsNode(contacts_repository.ContactsNode node)
      : this(node.id, node.remarkName);

  @override
  List<Object?> get props => [id, remarkName];
}

class Edge extends Equatable {
  final Node node;
  final String? cursour;

  const Edge(this.node, this.cursour);
  Edge.fromContactsEdge(contacts_repository.ContactsEdge edge)
      : this(Node.fromContactsNode(edge.node), edge.cursour);

  @override
  List<Object?> get props => [node, cursour];
}

List<Edge> fromContactsEdgeList(
    List<contacts_repository.ContactsEdge> contactsEdges) {
  List<Edge> edges = [];
  for (var contactsEdge in contactsEdges) {
    edges.add(Edge.fromContactsEdge(contactsEdge));
  }
  return edges;
}

class Connection extends Equatable {
  final contacts_repository.ContactsError error;
  final int totalCount;
  final PageInfo pageInfo;
  final List<Edge> edges;

  const Connection(
      {this.error = contacts_repository.ContactsError.none,
      required this.totalCount,
      required this.pageInfo,
      required this.edges});
  Connection.error(this.error)
      : totalCount = 0,
        pageInfo = const PageInfo('', false),
        edges = [];

  Connection.fromContactsConnection(
      contacts_repository.ContactsConnection connection)
      : this(
            edges: fromContactsEdgeList(connection.edges),
            totalCount: connection.totalCount,
            pageInfo: PageInfo.fromContactsPageInfo(connection.pageInfo),
            error: connection.error);

  @override
  List<Object?> get props => [error, totalCount, pageInfo, edges];

  @override
  bool get stringify => true;
}

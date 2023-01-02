import 'dart:developer';

import 'error.dart';

const String _kLogSource = 'contacts_repository';

class PageInfo {
  String endCursor;
  bool hasNextPage;

  PageInfo(this.endCursor, this.hasNextPage);
}

class Node {
  final String userId;
  final String contactsId;
  final String message;
  final DateTime updateTime;

  Node(this.userId, this.contactsId, this.message, this.updateTime);
}

class Edge {
  final Node node;
  final String? cursour;

  Edge(this.node, this.cursour);
}

class AddContactsApplyConnection {
  final ContactsError error;
  final int totalCount;
  final PageInfo pageInfo;
  final List<Edge> edges;

  AddContactsApplyConnection(
      {this.error = ContactsError.none,
      required this.totalCount,
      required this.pageInfo,
      required this.edges});
  AddContactsApplyConnection.error(this.error)
      : totalCount = 0,
        pageInfo = PageInfo('', false),
        edges = [];
}

AddContactsApplyConnection toAddContactsApplyConnection(
    final Map<String, dynamic> addContactsApplyConnection) {
  ContactsError error = ContactsError.none;
  int totalCount = 0;
  PageInfo pageInfo = PageInfo('', false);
  List<Edge> edges = [];
  try {
    totalCount = addContactsApplyConnection['totalCount'] as int;
    final pageInfoJson = addContactsApplyConnection['pageInfo'];
    pageInfo.endCursor = pageInfoJson['endCursor'] as String;
    pageInfo.hasNextPage = pageInfoJson['hasNextPage'] as bool;

    final edgesJson = addContactsApplyConnection['edges'];
    for (var edgeJson in edgesJson) {
      final cursor = edgeJson['cursor'] as String?;
      final nodeJson = edgeJson['node'];
      final userId = nodeJson['userId'] as String;
      final contactsId = nodeJson['contactsId'] as String;
      final message = nodeJson['message'] as String;
      final updateTime = nodeJson['updateTime'] as String;
      edges.add(Edge(
          Node(userId, contactsId, message, DateTime.parse(updateTime)),
          cursor));
    }
  } catch (e) {
    log(name: _kLogSource, e.toString());
    error = ContactsError.clientInternalError;
  }
  return AddContactsApplyConnection(
      error: error, totalCount: totalCount, pageInfo: pageInfo, edges: edges);
}

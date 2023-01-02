import 'dart:developer';

import 'error.dart';

class ContactsPageInfo {
  String endCursor;
  bool hasNextPage;

  ContactsPageInfo(this.endCursor, this.hasNextPage);
}

class ContactsNode {
  final String id;
  final String remarkName;

  ContactsNode(this.id, this.remarkName);
}

class ContactsEdge {
  final ContactsNode node;
  final String? cursour;

  ContactsEdge(this.node, this.cursour);
}

class ContactsConnection {
  final ContactsError error;
  final int totalCount;
  final ContactsPageInfo pageInfo;
  final List<ContactsEdge> edges;

  ContactsConnection(
      {this.error = ContactsError.none,
      required this.totalCount,
      required this.pageInfo,
      required this.edges});
  ContactsConnection.error(this.error)
      : totalCount = 0,
        pageInfo = ContactsPageInfo('', false),
        edges = [];
}

ContactsConnection toContactsConnection(
    final Map<String, dynamic> contactsConnection) {
  const String kLogSource = 'contacts_repository';
  ContactsError error = ContactsError.none;
  int totalCount = 0;
  ContactsPageInfo pageInfo = ContactsPageInfo('', false);
  List<ContactsEdge> edges = [];
  try {
    totalCount = contactsConnection['totalCount'] as int;
    final pageInfoJson = contactsConnection['pageInfo'];
    pageInfo.endCursor = pageInfoJson['endCursor'] as String;
    pageInfo.hasNextPage = pageInfoJson['hasNextPage'] as bool;

    final edgesJson = contactsConnection['edges'];
    for (var edgeJson in edgesJson) {
      final cursor = edgeJson['cursor'] as String?;
      final nodeJson = edgeJson['node'];
      final id = nodeJson['id'] as String;
      final remarkName = nodeJson['remarkName'] as String;
      edges.add(ContactsEdge(ContactsNode(id, remarkName), cursor));
    }
  } catch (e) {
    log(name: kLogSource, e.toString());
    error = ContactsError.clientInternalError;
  }
  return ContactsConnection(
      error: error, totalCount: totalCount, pageInfo: pageInfo, edges: edges);
}

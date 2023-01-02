import 'dart:developer';
import 'dart:ffi';

import 'package:graphql/client.dart';
import 'models/models.dart' as models;
import 'api/api.dart' as api;

const _kLogSource = 'contacts_repository';

class ApiClient {
  late GraphQLClient _graphQLClient;
  String token;

  ApiClient({required final String url, required this.token}) {
    final httpLink = HttpLink(url);
    final authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    Link link = authLink.concat(httpLink);
    _graphQLClient = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  // Future<Bool> applyAddContacts() async {
    



  //   return true;
  // }
}

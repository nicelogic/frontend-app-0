import 'dart:developer';

import 'package:graphql/client.dart';
import 'models/models.dart' as models;
import 'api/api.dart' as api;

const kLogSource = 'user_repository';

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

  Future<models.User> me() async {
    try {
      const gqlStr = api.me;
      final meResult = await _graphQLClient.query(QueryOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: const <String, dynamic>{}));
      if (meResult.hasException) {
        throw meResult.exception!;
      }
      final data = meResult.data![api.meResult];
      final auth = models.User(
          id: data[api.id] as String,
          name: data[api.name] as String,
          data: data[api.data] as String,
          error: models.UserError.none);
      return auth;
    } on ServerException catch (e) {
      log(name: kLogSource, e.toString());
      return const models.User.error(error: models.UserError.networkError);
    } on OperationException catch (e) {
      log(name: kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.User.error(error: error.parseUserServiceError());
      }
    } catch (e) {
      log(name: kLogSource, e.toString());
    }
    return const models.User.error(error: models.UserError.clientInternalError);
  }
}

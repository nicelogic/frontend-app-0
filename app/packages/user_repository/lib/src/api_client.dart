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
          fetchPolicy: FetchPolicy.noCache,
          variables: const <String, dynamic>{}));
      if (meResult.hasException) {
        throw meResult.exception!;
      }
      final data = meResult.data![api.meResult];
      final user = models.User(
          id: data[api.id] as String,
          name: data[api.name] as String,
          data: data[api.data] as String,
          error: models.UserError.none);
      return user;
    } on NetworkException catch (e) {
      log(name: kLogSource, e.toString());
      return models.User.error(error: models.UserError.networkError);
    } on OperationException catch (e) {
      log(name: kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.User.error(error: error.parseUserServiceError());
      }
    } catch (e) {
      log(name: kLogSource, e.toString());
    }
    return models.User.error(error: models.UserError.clientInternalError);
  }

  Future<models.Users> users({required String idOrName}) async {
    try {
      const gqlStr = api.users;
      final result = await _graphQLClient.query(QueryOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.noCache,
          variables: <String, dynamic>{api.idOrName: idOrName}));
      if (result.hasException) {
        throw result.exception!;
      }
      final data = result.data![api.usersResult];
      final users = {
        for (final user in data)
          user['id'] as String: models.User(
              id: user['id'],
              name: user['name'],
              data: user['data'],
              error: models.UserError.none)
      };
      return models.Users(users: users, error: models.UserError.none);
    } on NetworkException catch (e) {
      log(name: kLogSource, e.toString());
      return const models.Users.error(error: models.UserError.networkError);
    } on OperationException catch (e) {
      log(name: kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.Users.error(error: error.parseUserServiceError());
      }
    } catch (e) {
      log(name: kLogSource, e.toString());
    }
    return const models.Users.error(
        error: models.UserError.clientInternalError);
  }

  Future<models.User> updateUser(
      {required Map<String, String> properties}) async {
    try {
      final gqlStr = api.generateUpdateUserGql(properties);
      final result = await _graphQLClient.mutate(MutationOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.noCache,
          variables: properties));
      if (result.hasException) {
        throw result.exception!;
      }
      final data = result.data![api.updateUserResult];
      final user = models.User(
          id: data[api.id] as String,
          name: data[api.name] as String,
          data: data[api.data] as String,
          error: models.UserError.none);
      return user;
    } on NetworkException catch (e) {
      log(name: kLogSource, e.toString());
      return models.User.error(error: models.UserError.networkError);
    } on OperationException catch (e) {
      log(name: kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.User.error(error: error.parseUserServiceError());
      }
    } catch (e) {
      log(name: kLogSource, e.toString());
    }
    return models.User.error(error: models.UserError.clientInternalError);
  }
}

import 'dart:developer';

import 'package:graphql/client.dart';
import 'api/api.dart' as api;
import 'models/models.dart' as models;

const kLogSource = 'auth_repository';

class ApiClient {
  final GraphQLClient _graphQLClient;

  const ApiClient({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  factory ApiClient.create({required String url}) {
    final httpLink = HttpLink(url);
    final link = Link.from([httpLink]);
    return ApiClient(
        graphQLClient: GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    ));
  }

  Future<models.Auth> signUpByUserName(
      {required String userName, required String password}) async {
    try {
      const gqlStr = api.kSignUpByUserName;
      final signUpResult = await _graphQLClient.mutate(MutationOptions(
          document: gql(gqlStr),
          variables: <String, dynamic>{
            api.kUserName: userName,
            api.kPassword: password
          }));
      if (signUpResult.hasException) {
        throw signUpResult.exception!;
      }
      final data = signUpResult.data![api.kSignUpByUserNameResult];
      final auth = models.Auth(
          refreshToken: data[api.kRefreshToken] as String,
          accessToken: data[api.kAccessToken] as String);
      return auth;
    } on ServerException catch (e) {
      log(name: kLogSource, e.toString());
      return const models.Auth(error: models.AuthError.networkError);
    } on OperationException catch (e) {
      log(name: kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.Auth(
            error: models.toErrorEnum[error] ??
                models.AuthError.serverInternalError);
      }
    } catch (e) {
      log(name: kLogSource, e.toString());
    }
    return const models.Auth(error: models.AuthError.clientInternalError);
  }

  Future<models.Auth> signInByUserName(
      {required String userName, required String password}) async {
    try {
      const gqlStr = api.kSignInByUserName;
      final signInResult = await _graphQLClient.query(QueryOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: <String, dynamic>{
            api.kUserName: userName,
            api.kPassword: password
          }));
      if (signInResult.hasException) {
        throw signInResult.exception!;
      }
      final data = signInResult.data![api.kSignInByUserNameResult];
      final auth = models.Auth(
          refreshToken: data[api.kRefreshToken] as String,
          accessToken: data[api.kAccessToken] as String);
      return auth;
    } on ServerException catch (e) {
      log(name: kLogSource, e.toString());
      return const models.Auth(error: models.AuthError.networkError);
    } on OperationException catch (e) {
      log(name: kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.Auth(
            error: models.toErrorEnum[error] ??
                models.AuthError.serverInternalError);
      }
    } catch (e) {
      log(name: kLogSource, e.toString());
    }
    return const models.Auth(error: models.AuthError.clientInternalError);
  }

  Future<models.Auth> refreshToken({required String refreshToken}) async {
    try {
      const gqlStr = api.kRefreshTokenGql;
      final refreshTokenResult = await _graphQLClient.query(QueryOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: <String, dynamic>{api.kRefreshTokenParam: refreshToken}));
      if (refreshTokenResult.hasException) {
        throw refreshTokenResult.exception!;
      }
      final data = refreshTokenResult.data![api.kRefreshTokenResult];
      final auth = models.Auth(
          refreshToken: data[api.kRefreshToken] as String,
          accessToken: data[api.kAccessToken] as String);
      return auth;
    } on ServerException catch (e) {
      log(name: kLogSource, e.toString());
      return const models.Auth(error: models.AuthError.networkError);
    } on OperationException catch (e) {
      log(name: kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.Auth(
            error: models.toErrorEnum[error] ??
                models.AuthError.serverInternalError);
      }
    } catch (e) {
      log(name: kLogSource, e.toString());
    }
    return const models.Auth(error: models.AuthError.clientInternalError);
  }
}

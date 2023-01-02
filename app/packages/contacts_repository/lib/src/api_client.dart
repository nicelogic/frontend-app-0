import 'dart:developer';

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

  Future<models.ContactsError> applyAddContacts(
      {required String userName,
      required String contactsId,
      required String remarkName,
      required String message}) async {
    try {
      const gqlStr = api.kApplyAddContacts;
      final result = await _graphQLClient.mutate(MutationOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            api.userName: userName,
            api.contactsId: contactsId,
            api.remarkName: remarkName,
            api.message: message
          }));
      if (result.hasException) {
        throw result.exception!;
      }
      return models.ContactsError.none;
    } on NetworkException catch (e) {
      log(name: _kLogSource, e.toString());
      return models.ContactsError.networkError;
    } on OperationException catch (e) {
      log(name: _kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return error.parseError();
      }
    } catch (e) {
      log(name: _kLogSource, e.toString());
    }
    return models.ContactsError.clientInternalError;
  }

  Future<models.AddContactsApplyConnection> addContactsApplys(
      {required int first, final String? after}) async {
    try {
      const gqlStr = api.addContactsApplys;
      final result = await _graphQLClient.query(QueryOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.noCache,
          variables: <String, dynamic>{api.first: first, api.after: after}));
      if (result.hasException) {
        throw result.exception!;
      }
      final data =
          result.data![api.addContactsApplysResult] as Map<String, dynamic>;
      final addContactsApplyConnection =
          models.toAddContactsApplyConnection(data);
      return addContactsApplyConnection;
    } on NetworkException catch (e) {
      log(name: _kLogSource, e.toString());
      return models.AddContactsApplyConnection.error(
          models.ContactsError.networkError);
    } on OperationException catch (e) {
      log(name: _kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.AddContactsApplyConnection.error(error.parseError());
      }
    } catch (e) {
      log(name: _kLogSource, e.toString());
    }
    return models.AddContactsApplyConnection.error(
        models.ContactsError.clientInternalError);
  }

  Future<models.ContactsError> replyAddContacts({
    required String contactsId,
    required bool isAgree,
    required String remarkName,
  }) async {
    try {
      const gqlStr = api.replyAddContacts;
      final result = await _graphQLClient.mutate(MutationOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            api.contactsId: contactsId,
            api.isAgree: isAgree,
            api.remarkName: remarkName,
          }));
      if (result.hasException) {
        throw result.exception!;
      }
      return models.ContactsError.none;
    } on NetworkException catch (e) {
      log(name: _kLogSource, e.toString());
      return models.ContactsError.networkError;
    } on OperationException catch (e) {
      log(name: _kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return error.parseError();
      }
    } catch (e) {
      log(name: _kLogSource, e.toString());
    }
    return models.ContactsError.clientInternalError;
  }

  Future<models.ContactsConnection> contacts(
      {required int first, final String? after}) async {
    try {
      const gqlStr = api.contacts;
      final result = await _graphQLClient.query(QueryOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.noCache,
          variables: <String, dynamic>{api.first: first, api.after: after}));
      if (result.hasException) {
        throw result.exception!;
      }
      final data = result.data![api.contactsResult] as Map<String, dynamic>;
      final contactsConnection = models.toContactsConnection(data);
      return contactsConnection;
    } on NetworkException catch (e) {
      log(name: _kLogSource, e.toString());
      return models.ContactsConnection.error(models.ContactsError.networkError);
    } on OperationException catch (e) {
      log(name: _kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return models.ContactsConnection.error(error.parseError());
      }
    } catch (e) {
      log(name: _kLogSource, e.toString());
    }
    return models.ContactsConnection.error(
        models.ContactsError.clientInternalError);
  }

  Future<models.ContactsError> removeContacts({
    required String contactsId,
  }) async {
    try {
      const gqlStr = api.removeContacts;
      final result = await _graphQLClient.mutate(MutationOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            api.contactsId: contactsId,
          }));
      if (result.hasException) {
        throw result.exception!;
      }
      return models.ContactsError.none;
    } on NetworkException catch (e) {
      log(name: _kLogSource, e.toString());
      return models.ContactsError.networkError;
    } on OperationException catch (e) {
      log(name: _kLogSource, e.toString());
      if (e.graphqlErrors.isNotEmpty) {
        final error = e.graphqlErrors[0].message;
        return error.parseError();
      }
    } catch (e) {
      log(name: _kLogSource, e.toString());
    }
    return models.ContactsError.clientInternalError;
  }
}

import 'dart:developer';

import 'api_client.dart';
import 'models/models.dart' as models;

const _kLogSource = 'user_repository';

class ContactsRepository {
  final ApiClient _apiClient;

  ContactsRepository({required String url, required String token})
      : _apiClient = ApiClient(url: url, token: token) {
    log(name: _kLogSource, 'init user repository');
  }
  void updateToken(final String token) {
    _apiClient.token = token;
  }

  Future<models.ContactsError> applyAddContacts(
      {required String userName,
      required String contactsId,
      required String remarkName,
      required String message}) async {
    final error = await _apiClient.applyAddContacts(
        userName: userName,
        contactsId: contactsId,
        remarkName: remarkName,
        message: message);
    return error;
  }

  Future<models.AddContactsApplyConnection> addContactsApplys(
      {required int first, final String? after}) async {
    final connection =
        await _apiClient.addContactsApplys(first: first, after: after);
    return connection;
  }

  Future<models.ContactsError> replyAddContacts({
    required String contactsId,
    required bool isAgree,
    required String remarkName,
  }) async {
    final error = await _apiClient.replyAddContacts(
        contactsId: contactsId, isAgree: isAgree, remarkName: remarkName);
    return error;
  }
}

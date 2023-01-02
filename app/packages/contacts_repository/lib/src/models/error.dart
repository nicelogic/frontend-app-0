enum ContactsError {
  none,
  serverInternalError,
  tokenInvalid,
  tokenExpired,
  clientInternalError,
  networkError,
  contactsAddedMe,
  canNotAddMyselfAsFriend,
  invalidContactsId,
}

extension ErrorParsing on String {
  static const _kServerInternalError = "server internal error";
  static const _kTokenInvalid = "token invalid";
  static const _kTokenExpired = "token expired";
  static const _contactsAddedMe = "contacts added me";
  static const _canNotAddMyselfAsFriend = "can not add myself as a friend";
  static const _invalidContactsId = "invalid contacts id";
  static const _toErrorEnum = <String, ContactsError>{
    _kServerInternalError: ContactsError.serverInternalError,
    _kTokenInvalid: ContactsError.tokenInvalid,
    _kTokenExpired: ContactsError.tokenExpired,
    _contactsAddedMe: ContactsError.contactsAddedMe,
    _canNotAddMyselfAsFriend: ContactsError.canNotAddMyselfAsFriend,
    _invalidContactsId: ContactsError.invalidContactsId,
  };
  ContactsError parseError() {
    return _toErrorEnum[this] ?? ContactsError.serverInternalError;
  }
}

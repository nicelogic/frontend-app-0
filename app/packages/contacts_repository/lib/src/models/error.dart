enum ContactsError {
  none,
  serverInternalError,
  tokenInvalid,
  tokenExpired,
  clientInternalError,
  networkError,
  contactsAddedMe,
}

extension UserErrorParsing on String {
  static const _kServerInternalError = "server internal error";
  static const _kTokenInvalid = "token invalid";
  static const _kTokenExpired = "token expired";
  static const _kContactsAddedMe = "contacts added me";
  static const _toErrorEnum = <String, ContactsError>{
    _kServerInternalError: ContactsError.serverInternalError,
    _kTokenInvalid: ContactsError.tokenInvalid,
    _kTokenExpired: ContactsError.tokenExpired,
    _kContactsAddedMe: ContactsError.contactsAddedMe
  };
  ContactsError parseUserServiceError() {
    return _toErrorEnum[this] ?? ContactsError.serverInternalError;
  }
}

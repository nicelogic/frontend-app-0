enum UserError {
  none,
  serverInternalError,
  userNotExist,
  tokenInvalid,
  tokenExpired,
  clientInternalError,
  networkError,
}

extension UserErrorParsing on String {
  static const _kServerInternalError = "server internal error";
  static const _kUserNotExist = "user not exist";
  static const _kTokenInvalid = "token invalid";
  static const _kTokenExpired = "token expired";
  static const _toErrorEnum = <String, UserError>{
    _kServerInternalError: UserError.serverInternalError,
    _kUserNotExist: UserError.userNotExist,
    _kTokenInvalid: UserError.tokenInvalid,
    _kTokenExpired: UserError.tokenExpired,
  };
  UserError parseUserServiceError() {
    return _toErrorEnum[this] ?? UserError.serverInternalError;
  }
}

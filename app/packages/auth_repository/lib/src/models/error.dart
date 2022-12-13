enum AuthError {
  none,
  serverInternalError,
  clientInternalError,
  networkError,
  userExist,
  userNotExist,
  pwdWrong,
  tokenInvalid,
  tokenExpired,
}

const kServerInternalError = "server internal error";
const kUserExist = "user already exist";
const kUserNotExist = "user not exist";
const kPwdWrong = "password wrong";
const kTokenInvalid = "token invalid";
const kTokenExpired = "token expired";
const toErrorEnum = <String, AuthError>{
  kServerInternalError: AuthError.serverInternalError,
  kUserExist: AuthError.userExist,
  kUserNotExist: AuthError.userNotExist,
  kPwdWrong: AuthError.pwdWrong,
  kTokenInvalid: AuthError.tokenInvalid,
  kTokenExpired: AuthError.tokenExpired,
};


enum AuthError {
  none,
  serverInternalError,
  clientInternalError,
  networkError,
  userExist,
  userNotExist,
  pwdWrong,
}

const kServerInternalError = "server internal error";
const kUserExist = "user already exist";
const kUserNotExist = "user not exist";
const kPwdWrong = "password wrong";
const toErrorEnum = <String, AuthError>{
  kServerInternalError: AuthError.serverInternalError,
  kUserExist: AuthError.userExist,
  kUserNotExist: AuthError.userNotExist,
  kPwdWrong: AuthError.pwdWrong
};

const kUserName = 'userName';
const kPassword = 'pwd';
const kSignInByUserNameResult = 'signInByUserName';
const kSignInByUserName = ''' 
query signInByUserName(\$$kUserName: String!, \$$kPassword: String!) {
  signInByUserName(userName: \$$kUserName, pwd: \$$kPassword) {
    refresh_token
    access_token
  }
}
''';

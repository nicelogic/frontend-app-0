const kSignInByUserNameResult = 'signInByUserName';
const kSignInByUserName = r''' 
query signInByUserName($userName: String!, $pwd: String!) {
  signInByUserName(userName: $userName, pwd: $pwd) {
    refresh_token
    access_token
  }
}
''';

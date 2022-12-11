const kSignUpByUserNameResult = 'signUpWithUserName';
const kSignUpByUserName = r'''
mutation signUpByUserName($userName: String!, $pwd: String!) {
  signUpByUserName(userName: $userName, pwd: $pwd) {
    token
  }
}
''';

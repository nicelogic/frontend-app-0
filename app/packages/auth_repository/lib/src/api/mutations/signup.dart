const kSignUpByUserNameResult = 'signUpByUserName';
const kSignUpByUserName = '''
mutation $kSignUpByUserNameResult(\$userName: String!, \$pwd: String!) {
  $kSignUpByUserNameResult(userName: \$userName, pwd: \$pwd) {
    refresh_token
    access_token
  }
}
''';

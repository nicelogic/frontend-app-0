const kRefreshTokenResult = 'refreshToken';
const kRefreshToken = r'''
query refreshToken($refreshToken: String!){
  refreshToken(refreshToken: $refreshToken){
    refresh_token
    access_token
  }
}
''';

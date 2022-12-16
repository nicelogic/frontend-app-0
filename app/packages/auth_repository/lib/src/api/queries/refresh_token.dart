const kRefreshTokenParam = 'refreshToken';
const kRefreshToken = 'refresh_token';
const kAccessToken = 'access_token';
const kRefreshTokenResult = 'refreshToken';
const kRefreshTokenGql = '''
query refreshToken(\$$kRefreshTokenParam: String!){
  refreshToken(refreshToken: \$$kRefreshTokenParam){
    $kRefreshToken
    $kAccessToken
  }
}
''';

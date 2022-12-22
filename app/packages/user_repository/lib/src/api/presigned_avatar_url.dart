const preSignedUrl = 'preSignedUrl';
const anonymousAccessUrl = 'anonymousAccessUrl';
const preSignedAvatarUrlResult = 'preSignedAvatarUrl';
const preSignedAvatarUrl = '''
query $preSignedAvatarUrlResult{
  $preSignedAvatarUrlResult{
    $preSignedUrl
    $anonymousAccessUrl
  }
}
''';

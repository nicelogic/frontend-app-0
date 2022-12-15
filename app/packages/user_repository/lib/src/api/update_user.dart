const updateUserResult = 'updateUser';

String generateUpdateUserGql(Map<String, String> properties) {
  String variableDefinitions = '';
  String variables = '';
  properties.forEach((key, value) {
    variableDefinitions += ' \$$key: String ';
    variables += ' $key: \$$key ';
  });

  final updateUser = '''
mutation $updateUserResult($variableDefinitions){
  $updateUserResult(changes: { $variables }){
    id
    name
    data
  }
}
''';
  return updateUser;
}

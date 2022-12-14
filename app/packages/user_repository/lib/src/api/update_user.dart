const updateUserResult = 'updateUser';
const updateUser = '''
mutation $updateUserResult(\$name: String, \$signature: String){
  $updateUserResult(changes: {name: \$name, signature: \$signature}){
    id
    name
    data
  }
}
''';

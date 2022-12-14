const usersResult = 'users';
const users = '''
query $usersResult(\$idOrName: String!){
  $usersResult(idOrName: \$idOrName){
    id
    name
    data
  }
}
''';

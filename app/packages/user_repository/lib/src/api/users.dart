const usersResult = 'users';
const idOrName = 'idOrName';
const users = '''
query $usersResult(\$$idOrName: String!){
  $usersResult($idOrName: \$$idOrName){
    id
    name
    data
  }
}
''';

const first = 'first';
const after = 'after';
const addContactsApplysResult = 'addContactsApplys';
const addContactsApplys = '''
query $addContactsApplysResult(
\$$first: Int = 100
\$$after: String
){
  $addContactsApplysResult($first: \$$first, $after: \$$after){
    totalCount
    edges{
      node {
        userId
        contactsId
        updateTime
        message
      }
      cursor
    }
    pageInfo {
      endCursor
      hasNextPage
    }
  }
}
''';

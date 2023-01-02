import 'add_contacts_applys.dart';

const contactsResult = 'contacts';
const contacts = '''
query $contactsResult(\$$first: Int, \$$after: String){
  $contactsResult($first: \$$first, $after: \$$after){
    totalCount
    pageInfo {
      endCursor
      hasNextPage
    }
    edges{
      cursor
      node {
        id
        remarkName
      }
    }
  }
}
''';

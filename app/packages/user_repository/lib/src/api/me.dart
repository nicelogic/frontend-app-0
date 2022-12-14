const id = 'id';
const name = 'name';
const data = 'data';
const meResult = 'me';
const me = '''
query $meResult {
  $meResult{
    $id
    $name
    $data
  }
}
''';

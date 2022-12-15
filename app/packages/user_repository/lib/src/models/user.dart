import 'error.dart';

class User {
  final String id;
  final String name;
  final String data;
  final UserError error;

  User(
      {required this.id,
      required this.name,
      required this.data,
      required this.error});

  const User.error({required this.error})
      : id = '',
        name = '',
        data = '';
}

class Users {
  final Map<String, User> users;
  final UserError error;

  Users({required this.users, required this.error});
  const Users.error({required this.error}) : users = const {};
}

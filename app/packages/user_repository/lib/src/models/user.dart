import 'dart:convert';

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
      this.error = UserError.none});
  User.error({required UserError error})
      : this(id: '', name: '', data: '', error: error);
}

class Users {
  final Map<String, User> users;
  final UserError error;

  Users({required this.users, required this.error});
  const Users.error({required this.error}) : users = const {};
}

extension UserProperties on User {
  String get signature {
    if (data.isEmpty) {
      return "";
    }
    Map<String, dynamic> properties = jsonDecode(data);
    final signature = properties['signature'];
    return signature;
  }

  String get avatarUrl {
    if (data.isEmpty) {
      return "";
    }
    Map<String, dynamic> properties = jsonDecode(data);
    return properties['avatar_url'];
  }
}

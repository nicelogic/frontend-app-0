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

const kAvatarUrl = 'avatar_url';

extension UserProperties on User {
  String get signature {
    if (data.isEmpty) {
      return "";
    }
    try {
      Map<String, dynamic> properties = jsonDecode(data);
      final signature = properties['signature'] as String;
      return signature;
    } catch (e) {
      return '';
    }
  }

  String get avatarUrl {
    if (data.isEmpty) {
      return "";
    }
    try {
      Map<String, dynamic> properties = jsonDecode(data);
      return properties[kAvatarUrl] as String;
    } catch (e) {
      return '';
    }
  }
}

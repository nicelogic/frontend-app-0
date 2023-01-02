import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

class QueriedContacts extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;

  const QueriedContacts(this.id, this.name, this.avatarUrl);
  QueriedContacts.fromUser(User user)
      : this(user.id, user.name, user.avatarUrl);

  @override
  List<Object?> get props => [id, name, avatarUrl];

  @override
  bool get stringify => true;
}

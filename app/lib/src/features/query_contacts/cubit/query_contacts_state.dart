part of 'query_contacts_cubit.dart';

class QueryContactsState extends Equatable {
  final List<QueriedContacts> queriedContactsList;
  final UserError error;

  const QueryContactsState(
      {required this.queriedContactsList, this.error = UserError.none});
  QueryContactsState.error(this.error) : queriedContactsList = [];

  @override
  List<Object> get props => [queriedContactsList, error];
}

class QueryContactsInitial extends QueryContactsState {
  const QueryContactsInitial() : super(queriedContactsList: const []);
}

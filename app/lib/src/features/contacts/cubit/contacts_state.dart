part of 'contacts_cubit.dart';

@JsonSerializable(explicitToJson: true)
class ContactsState extends Equatable {
  final String userId;
  final List<List<Contacts>> cachedContacts;
  @JsonKey(ignore: true)
  final List<List<Contacts>>? contacts;
  @JsonKey(ignore: true)
  final String? nextPageKey;
  final int? nextPageIndex;
  final ContactsError error;
  @JsonKey(ignore: true)
  final DateTime? refreshTime;

  const ContactsState({
    required this.userId,
    required this.cachedContacts,
    this.contacts,
    this.nextPageKey,
    required this.nextPageIndex,
    required this.error,
    this.refreshTime,
  });

  ContactsState copyWith({
    final List<List<Contacts>>? cachedContacts,
    final List<List<Contacts>>? contacts,
    final String? nextPageKey,
    final int? nextPageIndex,
    final ContactsError? error,
    final DateTime? refreshTime,
  }) {
    return ContactsState(
        userId: userId,
        cachedContacts: cachedContacts ?? this.cachedContacts,
        contacts: contacts ?? this.contacts,
        nextPageKey: nextPageKey ?? this.nextPageKey,
        nextPageIndex: nextPageIndex,
        error: error ?? this.error,
        refreshTime: refreshTime ?? this.refreshTime);
  }

  @override
  List<Object?> get props => [
        cachedContacts,
        nextPageKey,
        contacts,
        nextPageIndex,
        error,
        refreshTime
      ];
}

class ContactsInitial extends ContactsState {
  const ContactsInitial({required super.userId})
      : super(
            cachedContacts: const [],
            contacts: const [],
            nextPageKey: null,
            nextPageIndex: 0,
            error: ContactsError.none);
}

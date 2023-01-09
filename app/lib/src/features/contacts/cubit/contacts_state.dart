part of 'contacts_cubit.dart';

@JsonSerializable(explicitToJson: true)
class ContactsState extends Equatable {
  final String userId;
  final Map<int, PagedContacts> cachedContacts;
  @JsonKey(ignore: true)
  final Map<int, PagedContacts> uiContacts;
  final ContactsError error;
  @JsonKey(ignore: true)
  final DateTime? refreshTime;

  const ContactsState({
    required this.userId,
    required this.cachedContacts,
    this.uiContacts = const {},
    required this.error,
    this.refreshTime,
  });

  ContactsState copyWith({
    final Map<int, PagedContacts>? cachedContacts,
    final Map<int, PagedContacts>? uiContacts,
    final ContactsError? error,
    final DateTime? refreshTime,
  }) {
    return ContactsState(
        userId: userId,
        cachedContacts: cachedContacts ?? this.cachedContacts,
        uiContacts: uiContacts ?? this.uiContacts,
        error: error ?? this.error,
        refreshTime: refreshTime ?? this.refreshTime);
  }

  @override
  List<Object?> get props => [cachedContacts, uiContacts, error, refreshTime];

  @override
  bool get stringify => true;
}

class ContactsInitial extends ContactsState {
  const ContactsInitial({required super.userId})
      : super(
            cachedContacts: const {},
            uiContacts: const {},
            error: ContactsError.none);
}

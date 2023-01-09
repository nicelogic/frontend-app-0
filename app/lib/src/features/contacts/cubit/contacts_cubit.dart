import 'dart:developer';

import 'package:contacts_repository/contacts_repository.dart';
import 'package:app/src/features/auth/auth.dart' as auth;
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart';
import '../models/models.dart';

part 'contacts_state.dart';
part 'contacts_cubit.g.dart';

const _kLogSource = 'ContactsCubit';

class ContactsCubit extends HydratedCubit<ContactsState> {
  final ContactsRepository contactsRepository;
  final UserRepository userRepository;
  final auth.AuthBloc authBloc;

  ContactsCubit(
      {required this.contactsRepository,
      required this.userRepository,
      required this.authBloc})
      : super(ContactsInitial(
          userId: authBloc.state.userId,
        ));

  PagedContacts? _fetchCachedPage(
      {required final int first, required final ContactsPageKey pageKey}) {
    return state.cachedContacts[pageKey.pageIndex];
  }

  Future<PagedContacts?> _fetchServerPage(
      {required final int first,
      required final ContactsPageKey pageKey}) async {
    try {
      final newItemsConnection = await contactsRepository.contacts(
          first: first,
          after: pageKey.pageCursor.isEmpty ? null : pageKey.pageCursor);
      if (newItemsConnection.error != ContactsError.none) {
        throw newItemsConnection.error;
      }
      final newItems = await Stream.fromIterable(newItemsConnection.edges)
          .asyncMap((e) async {
        final users = await userRepository.users(idOrName: e.node.id);
        var avatarUrl = '';
        if (users.users.isNotEmpty) {
          final user = users.users[e.node.id] as User;
          avatarUrl = user.avatarUrl;
        }
        return Contacts(
            id: e.node.id, name: e.node.remarkName, avatarUrl: avatarUrl);
      }).toList();
      final hasNextPage = newItemsConnection.pageInfo.hasNextPage;
      final nextPageCursor =
          hasNextPage ? newItemsConnection.pageInfo.endCursor ?? '' : '';
      final nextPageKey = hasNextPage
          ? ContactsPageKey(
              pageIndex: pageKey.pageIndex + 1, pageCursor: nextPageCursor)
          : null;
      final serverPage = PagedContacts(
          pageKey: pageKey, contacts: newItems, nextPageKey: nextPageKey);
      log(
          name: _kLogSource,
          '_upsertCachedPage, fetched by key($pageKey), ${serverPage.toSimpleString()}');
      return serverPage;
    } on ContactsError catch (e) {
      log(name: _kLogSource, '_fetchServerPage contacts error($e)');
      return null;
    } catch (error) {
      log(name: _kLogSource, '_fetchServerPage unknown error($error)');
      return null;
    }
  }

  fetchPage(
      {required final int first,
      required final ContactsPageKey pageKey}) async {
    try {
      final cachedPage = _fetchCachedPage(first: first, pageKey: pageKey);
      if (cachedPage != null) {
        log(
            name: _kLogSource,
            '_fetchCachedPage(${cachedPage.toSimpleString()})');
        var emptyContacts = <int, PagedContacts>{};
        final uiContacts = pageKey.pageIndex == 0
            ? emptyContacts
            : Map<int, PagedContacts>.from(state.uiContacts);
        uiContacts[pageKey.pageIndex] = cachedPage;
        final refreshTime =
            pageKey.pageIndex == 0 ? DateTime.now() : state.refreshTime;
        emit(state.copyWith(
            uiContacts: uiContacts,
            refreshTime: refreshTime,
            error: ContactsError.none));
        log(
            name: _kLogSource,
            '_fetchCachedPage, emit state(ui page num(${uiContacts.length})) ');
      } else {
        log(name: _kLogSource, '_fetchCachedPage, page($pageKey) not cached');
      }

      final serverPage = await _fetchServerPage(first: first, pageKey: pageKey);
      if (cachedPage == serverPage) {
        log(
            name: _kLogSource,
            '_fetchServerPage($pageKey), cachedPage == serverPage, do nothing');
        return;
      }
      log(
          name: _kLogSource,
          '_fetchServerPage(pageIndex($pageKey)) cachedPage != serverPage, serverPage(${serverPage?.toSimpleString()})');

      final nullPagedContacts = PagedContacts(
          pageKey: pageKey, contacts: const [], nextPageKey: null);
      final newCachedContacts =
          Map<int, PagedContacts>.from(state.cachedContacts);
      newCachedContacts[pageKey.pageIndex] = serverPage ?? nullPagedContacts;
      final newUiContacts = Map<int, PagedContacts>.from(state.uiContacts);
      newUiContacts[pageKey.pageIndex] = serverPage ?? nullPagedContacts;
      emit(state.copyWith(
          uiContacts: newUiContacts,
          cachedContacts: newCachedContacts,
          error: ContactsError.none));
    } catch (error) {
      log(name: _kLogSource, 'fetchPage unknown error($error)');
      return state.copyWith(
          error: ContactsError.clientInternalError,
          uiContacts: state.uiContacts);
    }
  }

  @override
  ContactsState? fromJson(Map<String, dynamic> json) {
    log(name: _kLogSource, 'fromJson($json)');
    final state = _$ContactsStateFromJson(json);
    final userId = authBloc.state.userId;
    log(
        name: _kLogSource,
        'current userId($userId), cached userId(${state.userId})');
    if (state.userId != userId) {
      return ContactsInitial(
        userId: authBloc.state.userId,
      );
    } else {
      return state;
    }
  }

  @override
  Map<String, dynamic>? toJson(ContactsState state) {
    final toJsonState = _$ContactsStateToJson(state);
    log(
        name: _kLogSource,
        'toJson($toJsonState), cached contacts page num(${state.cachedContacts.length})');
    state.cachedContacts.forEach((key, value) {
      log(
          name: _kLogSource,
          'toJson, cached contacts($key), item num(${value.contacts.length})');
    });
    return toJsonState;
  }
}

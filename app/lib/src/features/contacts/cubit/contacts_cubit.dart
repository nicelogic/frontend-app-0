import 'dart:developer';

import 'package:collection/collection.dart';
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

  fetchPage({required final int first, required final int pageIndex}) async {
    try {
      final cachedContactsHasThisPage = pageIndex < state.cachedContacts.length;
      final cachedThisPageContacts = cachedContactsHasThisPage
          ? state.cachedContacts.elementAt(pageIndex)
          : <Contacts>[];
      var aheadThisPageContacts = <List<Contacts>>[];
      for (int index = 0; index != pageIndex; ++index) {
        final curScreenContactsLen = state.contacts?.length ?? 0;
        if (index < curScreenContactsLen) {
          aheadThisPageContacts.add(state.contacts?.elementAt(index) ?? []);
        }
      }
      final addThisCachedPageCachedContacts = <List<Contacts>>[
        ...aheadThisPageContacts,
        cachedThisPageContacts
      ];
      final cachedContactsHasNextPage =
          pageIndex + 1 < state.cachedContacts.length;
      final cachedNextPageIndex =
          cachedContactsHasNextPage ? pageIndex + 1 : null;
      final refreshTime = pageIndex == 0 ? DateTime.now() : state.refreshTime;
      final cachedThisPageLastState = state.copyWith(
          contacts: addThisCachedPageCachedContacts,
          nextPageIndex: cachedNextPageIndex,
          refreshTime: refreshTime,
          error: ContactsError.none);
      log(
          name: _kLogSource,
          'get from cached page, pageIndex($pageIndex), cached contacts count(${addThisCachedPageCachedContacts.length}), cached contacts has this page($cachedContactsHasThisPage) nextPageIndex($cachedNextPageIndex), refreshTime($refreshTime)');
      for (var pageIndex = 0;
          pageIndex != addThisCachedPageCachedContacts.length;
          ++pageIndex) {
        final page = addThisCachedPageCachedContacts.elementAt(pageIndex);
        log(
            name: _kLogSource,
            'get from cached page, page index($pageIndex), item num(${page.length})');
      }
      if (cachedContactsHasThisPage) {
        emit(cachedThisPageLastState);
      } else {
        log(
            name: _kLogSource,
            'cached contacts has not this page, not update state and try to fetch from server');
      }

      final pageKey = state.nextPageKey;
      final newItemsConnection =
          await contactsRepository.contacts(first: first, after: pageKey);
      if (newItemsConnection.error != ContactsError.none) {
        throw newItemsConnection.error;
      }
      final nextPageKey = newItemsConnection.pageInfo.endCursor;
      log(
          name: _kLogSource,
          'fetchPage, key($pageKey), count(${newItemsConnection.totalCount}), nextPageKey($nextPageKey)');
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
      final lastCachedThisPageContacts =
          List<Contacts>.from(cachedThisPageContacts);

      if (const ListEquality().equals(lastCachedThisPageContacts, newItems)) {
        log(
            name: _kLogSource,
            'fetched this page(pageIndex($pageIndex)) state == cached this page state, do nothing');
      } else {
        final contacts = <List<Contacts>>[...aheadThisPageContacts, newItems];
        var updatedCachedContacts =
            List<List<Contacts>>.from(state.cachedContacts);
        if (pageIndex < updatedCachedContacts.length) {
          updatedCachedContacts[pageIndex] = newItems;
        } else {
          updatedCachedContacts.add(newItems);
        }
        final nextPageIndex =
            newItemsConnection.pageInfo.hasNextPage ? pageIndex + 1 : null;
        log(
            name: _kLogSource,
            'fetched this page(pageIndex($pageIndex)) state != cached this page state, update this page state, nextPageKey($nextPageKey), nextPageIndex($nextPageIndex), cached contacts num(${updatedCachedContacts.length}, contacts num(${contacts.length}))');
        for (var pageIndex = 0;
            pageIndex != updatedCachedContacts.length;
            ++pageIndex) {
          final page = updatedCachedContacts.elementAt(pageIndex);
          log(
              name: _kLogSource,
              'fetched this page, page index($pageIndex), item num(${page.length})');
        }
        emit(state.copyWith(
            nextPageKey: nextPageKey,
            nextPageIndex: nextPageIndex,
            cachedContacts: updatedCachedContacts,
            contacts: contacts));
      }
    } on ContactsError catch (e) {
      emit(state.copyWith(error: e));
    } catch (error) {
      log(name: _kLogSource, 'fetch page unknown error($error)');
      emit(state.copyWith(
        error: ContactsError.clientInternalError,
      ));
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
    for (var pageIndex = 0;
        pageIndex != state.cachedContacts.length;
        ++pageIndex) {
      final page = state.cachedContacts.elementAt(pageIndex);
      log(
          name: _kLogSource,
          'toJson, cached contacts page index($pageIndex), item num(${page.length})');
    }
    return toJsonState;
  }
}

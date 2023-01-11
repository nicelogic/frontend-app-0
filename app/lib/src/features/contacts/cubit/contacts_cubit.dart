import 'dart:async';
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
  final int pageSize;
  final pageKeyStreamController = StreamController<int>();
  ContactsError refreshPageError;

  ContactsCubit(
      {required this.contactsRepository,
      required this.userRepository,
      required this.authBloc,
      required this.pageSize})
      : refreshPageError = ContactsError.none,
        super(ContactsInitial(
          userId: authBloc.state.userId,
        )) {
    _sequentialRefreshPage();
  }

  _sequentialRefreshPage() async {
    await for (final pageIndex in pageKeyStreamController.stream) {
      final success = await _refreshPage(pageIndex: pageIndex);
      log(
          name: _kLogSource,
          '_refreshPage, pageIndex($pageIndex), is success($success)');
    }
  }

  fetchPage({required final ContactsPageKey pageKey}) async {
    final cachedPage = state.cachedContacts[pageKey.pageIndex];
    if (cachedPage != null) {
      log(
          name: _kLogSource,
          '_fetched CachedPage(${cachedPage.toSimpleString()})');
      var uiContacts = Map<int, PagedContacts>.from(state.uiContacts);
      if (pageKey.pageIndex == 0) {
        log(name: _kLogSource, 'begin to refresh contacts');
        uiContacts = <int, PagedContacts>{};
      }
      uiContacts[pageKey.pageIndex] = cachedPage;
      emit(state.copyWith(
          uiContacts: uiContacts,
          refreshTime:
              pageKey.pageIndex == 0 ? DateTime.now() : state.refreshTime,
          error: ContactsError.none));
    } else {
      log(name: _kLogSource, 'fetchPage, page($pageKey) not cached');
    }
    pageKeyStreamController.add(pageKey.pageIndex);
  }

  Future<bool> _refreshPage({required final int pageIndex}) async {
    try {
      log(name: _kLogSource, '_refreshPage, begin, pageIndex($pageIndex)');
      var pageCursor = '';
      if (pageIndex != 0) {
        if (refreshPageError != ContactsError.none) {
          log(
              name: _kLogSource,
              "_refreshPage, previous page refresh error, need'nt fresh subsequnce page");
          throw ContactsError.clientInternalError;
        }
        pageCursor = state.uiContacts[pageIndex - 1]!.nextPageKey!.pageCursor;
        log(
            name: _kLogSource,
            '_refreshPage, pageIndex($pageIndex), pageCursor($pageCursor)');
      } else {
        refreshPageError = ContactsError.none;
      }
      final newItemsConnection = await contactsRepository.contacts(
          first: pageSize, after: pageCursor.isEmpty ? null : pageCursor);
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
              pageIndex: pageIndex + 1, pageCursor: nextPageCursor)
          : null;
      final serverPage = PagedContacts(
          pageKey:
              ContactsPageKey(pageIndex: pageIndex, pageCursor: pageCursor),
          contacts: newItems,
          nextPageKey: nextPageKey);
      log(name: _kLogSource, '_refreshPage, ${serverPage.toSimpleString()}');

      final cachedPage = state.cachedContacts[pageIndex];
      if (cachedPage == serverPage) {
        log(
            name: _kLogSource,
            '_refreshPage($pageIndex), fetched server page == cachedPage, do nothing');
        return true;
      }
      log(
          name: _kLogSource,
          '_refreshPage, fetched server page(${serverPage.toSimpleString()}) != cachedPage');
      final newCachedContacts =
          Map<int, PagedContacts>.from(state.cachedContacts);
      newCachedContacts[pageIndex] = serverPage;
      final newUiContacts = Map<int, PagedContacts>.from(state.uiContacts);
      newUiContacts[pageIndex] = serverPage;
      emit(state.copyWith(
          uiContacts: newUiContacts,
          cachedContacts: newCachedContacts,
          error: ContactsError.none));
      return true;
    } on ContactsError catch (e) {
      refreshPageError = e;
      log(name: _kLogSource, '_refreshPage, has error($e)');
      emit(state.copyWith(error: e));
    } catch (error) {
      refreshPageError = ContactsError.clientInternalError;
      log(name: _kLogSource, '_refreshPage, has unknown error($error)');
      emit(state.copyWith(error: ContactsError.clientInternalError));
    }
    return false;
  }

  @override
  ContactsState? fromJson(Map<String, dynamic> json) {
    // log(name: _kLogSource, 'fromJson($json)');
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
    // log(
    //     name: _kLogSource,
    //     'toJson($toJsonState), cached contacts page num(${state.cachedContacts.length})');
    int? lastPageIndex;
    state.cachedContacts.forEach((key, value) {
      log(
          name: _kLogSource,
          'toJson, cached contacts($key), item num(${value.contacts.length})');
      if (lastPageIndex == null && value.nextPageKey == null) {
        lastPageIndex = key;
        log(name: _kLogSource, 'toJson, last page index($lastPageIndex)');
      }
    });
    /*
    [
      page 0
      page 1, next page key is null
      page 2
      page 3, next page key is null
      page 4
    ]
    handle this condition, remove first next page key is null's page's subsequence page
    */
    final cachedContactsLastPageIndex = state.cachedContacts.isNotEmpty
        ? state.cachedContacts.length - 1
        : null;
    if (lastPageIndex != null &&
        cachedContactsLastPageIndex != null &&
        lastPageIndex! < cachedContactsLastPageIndex) {
      log(
          name: _kLogSource,
          'toJson, last page index($lastPageIndex) < cached page last page index($cachedContactsLastPageIndex), remove subsequent cached page');
      state.cachedContacts.removeWhere((key, value) => key > lastPageIndex!);
    }
    return toJsonState;
  }
}

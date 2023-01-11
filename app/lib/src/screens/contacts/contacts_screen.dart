import 'dart:developer';

import 'package:app/src/configs/config.dart';
import 'package:app/src/features/add_contacts_applys/add_contacts_applys.dart';
import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/features/contacts/contacts.dart';
import 'package:app/src/features/repositorys/repositorys.dart';
import 'package:app/src/route.dart';
import 'package:app/src/widgets/widgets.dart' as widgets;
import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user_repository/user_repository.dart';

const _kLogSource = 'ContactsScreen';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (_) => AddContactsApplysCubit(
              contactsRepository:
                  context.read<RepositorysCubit>().contactsRepository,
              userRepository: context.read<RepositorysCubit>().userRepository,
              authBloc: context.read<AuthBloc>())
            ..fetchAddContactsApplys()),
      BlocProvider(
          create: (_) => ContactsCubit(
              contactsRepository:
                  context.read<RepositorysCubit>().contactsRepository,
              userRepository: context.read<RepositorysCubit>().userRepository,
              authBloc: context.read<AuthBloc>(),
              pageSize: Config.instance().contactsPageSize))
    ], child: _ContactsScreen());
  }
}

class _ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AddContactsApplysCubit, AddContactsApplysState>(
              listenWhen: (previous, current) =>
                  current.error != ContactsError.none,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.error.name)));
              }),
        ],
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Contacts',
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.add_circle_outline,
                  ),
                  onSelected: (String value) {
                    switch (value) {
                      case 'New Chat':
                        break;
                      case 'Add Contacts':
                        context.go('$routePathContacts/$routePathAddContacts');
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'New Chat', 'Add Contacts'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            body: Column(children: [
              Builder(builder: (context) {
                final state = context.watch<AddContactsApplysCubit>().state;
                final addContactsApplysCount = state.addContactsApplys.entries
                    .where((element) =>
                        element.value.replyAddContactsStatus ==
                        ReplyAddContactsStatus.none)
                    .length;
                return InkWell(
                    onTap: () {
                      context.go('$routePathContacts/$routePathNewContacts',
                          extra: context.read<AddContactsApplysCubit>());
                    },
                    child: widgets.ItemCard(
                      label: 'New Friends',
                      iconData: Icons.person_add,
                      badgeValue: addContactsApplysCount.toString(),
                    ));
              }),
              Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.fromLTRB(1, 10, 15, 10),
                  child: Builder(builder: (context) {
                    final contactsState = context.watch<ContactsCubit>().state;
                    return Center(
                      child:
                          Text('Contacts(${contactsState.uiContacts.length})'),
                    );
                  })),
              Expanded(
                  child: ContactsListView(
                      contactsRepository:
                          context.read<RepositorysCubit>().contactsRepository,
                      userRepository:
                          context.read<RepositorysCubit>().userRepository,
                      contactsCubit: context.read<ContactsCubit>())),
            ])));
  }
}

class ContactsListView extends StatefulWidget {
  final ContactsRepository contactsRepository;
  final UserRepository userRepository;
  final ContactsCubit contactsCubit;
  const ContactsListView(
      {super.key,
      required this.contactsRepository,
      required this.userRepository,
      required this.contactsCubit});

  @override
  ContactsListViewState createState() => ContactsListViewState();
}

class ContactsListViewState extends State<ContactsListView> {

  final PagingController<ContactsPageKey, Contacts> _pagingController =
      PagingController(
          firstPageKey: const ContactsPageKey(pageIndex: 0, pageCursor: ''),
          invisibleItemsThreshold:
              Config.instance().contactsInvisibleItemsThreshold);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      log(
          name: _kLogSource,
          'triger to fetch page($pageKey)');
      widget.contactsCubit.fetchPage(pageKey: pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactsCubit, ContactsState>(
        listener: (context, state) {
          final pagedContactsList = state.uiContacts.values.toList()
            ..sort((e1, e2) =>
                e1.pageKey.pageIndex.compareTo(e2.pageKey.pageIndex));
          final contacts =
              pagedContactsList.expand((element) => element.contacts).toList();
          final nextPageKey = pagedContactsList.last.nextPageKey;
          _pagingController.value = PagingState(
              nextPageKey: nextPageKey,
              error: state.error == ContactsError.none ? null : state.error,
              itemList: contacts);
          log(
              name: _kLogSource,
              'contacts ui update: contacts num(${contacts.length}), nextPageKey($nextPageKey), error(${state.error})');
          if (state.error != ContactsError.none) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content:
                      Text('load server contacts error(${state.error.name})')));
          }
        },
        child: RefreshIndicator(
            onRefresh: () => Future.sync(
                  () {
                    log(name: _kLogSource, 'trigger to refresh first page');
                    _pagingController.refresh();
                  },
                ),
            child: PagedListView<ContactsPageKey, Contacts>.separated(
              // separatorBuilder: (_, index) => const Divider(indent: 60, height: 0),
              separatorBuilder: (context, index) => const Divider(),
              padding: const EdgeInsets.all(16),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Contacts>(
                // animateTransitions: true,
                itemBuilder: (context, item, index) =>
                    ContactsItem(contacts: item),
                noItemsFoundIndicatorBuilder: ((context) =>
                    const widgets.FirstPageExceptionIndicator(
                        title: "don't have any friends yet")),
                firstPageErrorIndicatorBuilder: (context) =>
                    widgets.FirstPageExceptionIndicator(
                  title: 'Load contacts failed',
                  message: _pagingController.error.toString(),
                  onTryAgain: () => _pagingController.refresh(),
                ),
                newPageErrorIndicatorBuilder: (context) =>
                    widgets.NewPageErrorIndicator(
                  tip: 'Something went wrong. Tap to try again',
                  onTap: () => _pagingController.refresh(),
                ),
              ),
            )));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class ContactsItem extends StatelessWidget {
  final Contacts contacts;
  const ContactsItem({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  widgets.UserAvatar(
                    id: contacts.id,
                    name: contacts.name,
                    avatarUrl: contacts.avatarUrl,
                    radius: 28,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            contacts.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

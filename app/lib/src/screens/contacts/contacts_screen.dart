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
              authBloc: context.read<AuthBloc>()))
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
                  child: const Center(
                    child: Text('Contacts'),
                  )),
              Expanded(
                  child: ContactsListView(
                contactsRepository:
                    context.read<RepositorysCubit>().contactsRepository,
                userRepository: context.read<RepositorysCubit>().userRepository,
              )),
            ])));
  }
}

class ContactsListView extends StatefulWidget {
  final ContactsRepository contactsRepository;
  final UserRepository userRepository;
  const ContactsListView(
      {super.key,
      required this.contactsRepository,
      required this.userRepository});

  @override
  ContactsListViewState createState() => ContactsListViewState();
}

class ContactsListViewState extends State<ContactsListView> {
  static final _pageSize = Config.instance().contactsPageSize;

  final PagingController<String, Contacts> _pagingController = PagingController(
      firstPageKey: '',
      invisibleItemsThreshold:
          Config.instance().contactsInvisibleItemsThreshold);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(String pageKey) async {
    try {
      final newItemsConnection = await widget.contactsRepository
          .contacts(first: _pageSize, after: pageKey.isEmpty ? null : pageKey);
      if (newItemsConnection.error != ContactsError.none) {
        throw newItemsConnection.error;
      }
      final newItems = await Stream.fromIterable(newItemsConnection.edges)
          .asyncMap((e) async {
        final users = await widget.userRepository.users(idOrName: e.node.id);
        var avatarUrl = '';
        if (users.users.isNotEmpty) {
          final user = users.users[e.node.id] as User;
          avatarUrl = user.avatarUrl;
        }
        return Contacts(
            id: e.node.id, name: e.node.remarkName, avatarUrl: avatarUrl);
      }).toList();
      final hasNextPage = newItemsConnection.pageInfo.hasNextPage;
      if (hasNextPage) {
        final nextPageKey = newItemsConnection.pageInfo.endCursor;
        _pagingController.appendPage(newItems, nextPageKey);
      } else {
        _pagingController.appendLastPage(newItems);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
      onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
      child: PagedListView<String, Contacts>.separated(
        // separatorBuilder: (_, index) => const Divider(indent: 60, height: 0),
        separatorBuilder: (context, index) => const Divider(),
        padding: const EdgeInsets.all(16),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Contacts>(
          // animateTransitions: true,
          itemBuilder: (context, item, index) => ContactsItem(contacts: item),
          noItemsFoundIndicatorBuilder: ((context) =>
              const widgets.FirstPageExceptionIndicator(
                  title: "don't have any friends yet")),
          firstPageErrorIndicatorBuilder: (context) =>
              widgets.FirstPageExceptionIndicator(
            title: 'Load contacts failed',
            message: _pagingController.error.toString(),
            onTryAgain: () => _pagingController.refresh(),
          ),
        ),
      ));

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

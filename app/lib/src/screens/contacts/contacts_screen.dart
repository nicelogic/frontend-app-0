import 'package:app/src/features/add_contacts_applys/add_contacts_applys.dart';
import 'package:app/src/features/repositorys/repositorys.dart';
import 'package:app/src/route.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (_) => AddContactsApplysCubit(
              contactsRepository:
                  context.read<RepositorysCubit>().contactsRepository,
              userRepository: context.read<RepositorysCubit>().userRepository)
            ..fetchAddContactsApplys()),
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
                    child: ItemCard(
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
            ])));
  }
}

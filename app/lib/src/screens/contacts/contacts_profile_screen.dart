import 'package:app/src/features/apply_add_contacts/apply_add_contacts.dart'
    as apply_add_contacts;
import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/features/me/me.dart';
import 'package:app/src/features/query_contacts/query_contacts.dart'
    as query_contacts;
import 'package:contacts_repository/contacts_repository.dart'
    as contacts_repository;
import 'package:app/src/features/repositorys/cubit/repositorys_cubit.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsProfileScreen extends StatelessWidget {
  final query_contacts.QueriedContacts contacts;

  const ContactsProfileScreen({Key? key, required this.contacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => apply_add_contacts.ApplyAddContactsCubit(
                  contactsRepository:
                      context.read<RepositorysCubit>().contactsRepository)),
          BlocProvider(
            create: (_) => MeBloc(
                userRepository: context.read<RepositorysCubit>().userRepository,
                authBloc: context.read<AuthBloc>()),
          )
        ],
        child: _ContactProfileScreen(
          contacts: contacts,
        ));
  }
}

class _ContactProfileScreen extends StatelessWidget {
  final query_contacts.QueriedContacts contacts;

  const _ContactProfileScreen({Key? key, required this.contacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<apply_add_contacts.ApplyAddContactsCubit,
                  apply_add_contacts.ApplyAddContactsState>(
              listenWhen: (previous, current) =>
                  current.error != contacts_repository.ContactsError.none,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.error.name)));
              }),
          BlocListener<apply_add_contacts.ApplyAddContactsCubit,
                  apply_add_contacts.ApplyAddContactsState>(
              listenWhen: (previous, current) =>
                  current.applyAddContactsSuccess !=
                  previous.applyAddContactsSuccess,
              listener: (context, state) {
                if (state.applyAddContactsSuccess) {
                  String tapTip =
                      'request has been sent, please wait for agree';
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(tapTip)));
                }
              }),
        ],
        child: Scaffold(
            appBar: AppBar(
                leading: CloseButton(color: Theme.of(context).primaryColor),
                elevation: 0),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.fromLTRB(1, 10, 15, 20),
                      child: Row(children: [
                        const SizedBox(width: 20),
                        UserAvatar(
                          id: contacts.id,
                          name: contacts.name,
                          avatarUrl: contacts.avatarUrl,
                          radius: 34,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                contacts.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'id：${contacts.id}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ])),
                  InkWell(
                      child: const LabelCard(
                        label: 'Add to Contacts',
                      ),
                      onTap: () {
                        context
                            .read<apply_add_contacts.ApplyAddContactsCubit>()
                            .applyAddContacts(
                                userName: context.read<MeBloc>().state.me.name,
                                contactsId: contacts.id,
                                remarkName: contacts.name,
                                message: '');
                      }),
                ])));
  }
}

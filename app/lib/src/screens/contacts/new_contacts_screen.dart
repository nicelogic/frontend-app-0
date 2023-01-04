import 'package:app/src/features/add_contacts_applys/add_contacts_applys.dart';
import 'package:app/src/features/repositorys/repositorys.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewContactsScreen extends StatelessWidget {
  const NewContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (_) => AddContactsApplysCubit(
              contactsRepository:
                  context.read<RepositorysCubit>().contactsRepository)
            ..fetchAddContactsApplys()),
    ], child: _NewContactsScreen());
  }
}

class _NewContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Contacts'),
        ),
        body: Builder(builder: (context) {
          final state = context.watch<AddContactsApplysCubit>().state;
          return ListView.builder(
              itemCount: state.addContactsApplys.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final addContactsApply =
                    state.addContactsApplys.elementAt(index);
                return InkWell(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(1, 10, 15, 10),
                    child: Column(children: [
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 20),
                          UserAvatar(
                            id: addContactsApply.userId,
                            name: '',
                            avatarUrl: '',
                            radius: 34,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Text(addContactsApply.userId,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 10),
                                const Text('name： name')
                              ])),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () async {},
                            child: const Text('agree'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () async {},
                            child: const Text('reject'),
                          ),
                        ],
                      ),
                      if (index != (state.addContactsApplys.length - 1))
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                    ]),
                  ),
                );
              });
        }));
  }
}

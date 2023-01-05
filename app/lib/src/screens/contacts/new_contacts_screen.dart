import 'package:app/src/features/add_contacts_applys/add_contacts_applys.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewContactsScreen extends StatelessWidget {
  final AddContactsApplysCubit addContactsApplysCubit;

  const NewContactsScreen({required this.addContactsApplysCubit, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: addContactsApplysCubit, child: _NewContactsScreen());
  }
}

class _NewContactsScreen extends StatelessWidget {
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
              title: const Text('New Contacts'),
            ),
            body: Builder(builder: (context) {
              final state = context.watch<AddContactsApplysCubit>().state;
              return ListView.builder(
                  itemCount: state.addContactsApplys.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final addContactsApply =
                        state.addContactsApplys.entries.elementAt(index).value;
                    return InkWell(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(1, 10, 15, 10),
                        child: Column(children: [
                          Row(
                            children: <Widget>[
                              const SizedBox(width: 20),
                              UserAvatar(
                                id: addContactsApply.userId,
                                name: addContactsApply.userName,
                                avatarUrl: addContactsApply.userAvatarUrl,
                                radius: 34,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(addContactsApply.userId,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 10),
                                    Text('name： ${addContactsApply.userName}')
                                  ])),
                              if ([
                                ReplyAddContactsStatus.agree,
                                ReplyAddContactsStatus.none
                              ].contains(
                                  addContactsApply.replyAddContactsStatus))
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 15),
                                  ),
                                  onPressed: addContactsApply
                                              .replyAddContactsStatus ==
                                          ReplyAddContactsStatus.agree
                                      ? null
                                      : () {
                                          context
                                              .read<AddContactsApplysCubit>()
                                              .agree(
                                                  contactsId:
                                                      addContactsApply.userId,
                                                  remarkName: addContactsApply
                                                      .userName);
                                        },
                                  child: const Text('agree'),
                                ),
                              if ([
                                ReplyAddContactsStatus.ignore,
                                ReplyAddContactsStatus.none
                              ].contains(
                                  addContactsApply.replyAddContactsStatus))
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 15),
                                  ),
                                  onPressed: addContactsApply
                                              .replyAddContactsStatus ==
                                          ReplyAddContactsStatus.ignore
                                      ? null
                                      : () {
                                          context
                                              .read<AddContactsApplysCubit>()
                                              .reject(
                                                  contactsId:
                                                      addContactsApply.userId);
                                        },
                                  child: const Text('ignore'),
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
            })));
  }
}

import 'package:app/src/features/query_contacts/query_contacts.dart';
import 'package:app/src/features/repositorys/repositorys.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class AddContactsScreen extends StatelessWidget {
  const AddContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<QueryContactsCubit>(
          create: (BuildContext context) => QueryContactsCubit(
                userRepository: context.read<RepositorysCubit>().userRepository,
              ))
    ], child: _AddContactsScreen());
  }
}

class _AddContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
        body: FloatingSearchBar(
            leadingActions: const [Text(' \u{1F50D} ')],
            hint: 'id/name',
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 800),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            axisAlignment: isPortrait ? 0.0 : -1.0,
            openAxisAlignment: 0.0,
            width: isPortrait ? 600 : 500,
            debounceDelay: const Duration(milliseconds: 500),
            onQueryChanged: (query) {
              final idOrName = query;
              if (idOrName.trim().isNotEmpty) {
                context
                    .read<QueryContactsCubit>()
                    .queryContacts(idOrName: idOrName);
              }
            },
            // Specify a custom transition to be used for
            // animating between opened and closed stated.
            transition: CircularFloatingSearchBarTransition(),
            actions: [
              // FloatingSearchBarAction(
              //   showIfOpened: false,
              //   child: CircularButton(
              //     icon: const Icon(Icons.cancel),
              //     onPressed: () {},
              //   ),
              // ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (context, transition) {
              // final addedContacts = [];
              final contactsState = context.watch<QueryContactsCubit>().state;
              final contacts = contactsState.queriedContactsList;
              //need delete me & added contacts
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    for (final contact in contacts)
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(1, 10, 15, 10),
                          child: Column(children: [
                            Row(children: <Widget>[
                              const SizedBox(width: 20),
                              UserAvatar(
                                id: contact.id,
                                name: contact.name,
                                avatarUrl: contact.avatarUrl,
                                radius: 34,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(contact.id,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          // fontWeight: FontWeight.w500
                                        )),
                                    const SizedBox(height: 10),
                                    Text('name： ${contact.name}')
                                  ])),
                            ]),
                            if (contact != contacts.last)
                              const Divider(
                                height: 20,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                          ]),
                        ),
                        onTap: () {
                          //  context.router.push(StrangerProfileRoute( contact: contact,));
                        },
                      )
                  ]),
                ),
              );
            }));
  }
}

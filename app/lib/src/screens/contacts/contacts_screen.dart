import 'package:app/src/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '通讯录',
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
          Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.fromLTRB(1, 10, 15, 10),
              child: const Center(
                child: Text('Contacts'),
              )),
        ]));
  }
}

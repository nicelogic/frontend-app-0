import 'package:flutter/material.dart';

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
                  case '发起群聊':
                    break;
                  case '添加朋友':
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'发起群聊', '添加朋友'}.map((String choice) {
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
                child: Text('联系人'),
              )),
        ]));
  }
}

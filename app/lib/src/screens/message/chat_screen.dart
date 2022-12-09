import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              '聊天',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
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
        ]));
  }
}

import 'dart:developer';

import 'package:app/src/configs/configs.dart';
import 'package:flutter/material.dart';

const _kLogSource = 'widget(user_avatar)';

class UserAvatar extends StatelessWidget {
  final String id;
  final String name;
  final double? radius;
  const UserAvatar(
      {super.key, required this.id, required this.name, this.radius});

  @override
  Widget build(BuildContext context) {
    try {
      final userAvatar = CircleAvatar(
        radius: radius,
        foregroundImage: const NetworkImage(
            'https://tenant0.minio.env0.luojm.com:9443/app-0/users/test/avatar.png'),
        // backgroundImage: AssetImage(Config.instance().logoPath),
        backgroundColor: Color.fromARGB(255, id.codeUnitAt(0) % 255,
            id.codeUnitAt(1) % 255, id.codeUnitAt(2) % 255),
        child:
            Text(name.isNotEmpty ? name.substring(0, 1) : id.substring(0, 1)),
      );
      return userAvatar;
    } catch (e) {
      log(name: _kLogSource, 'has exception($e)');
      return CircleAvatar(
          radius: radius,
          foregroundImage: AssetImage(Config.instance().logoPath));
    }

  }
}

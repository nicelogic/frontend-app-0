import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String id;
  final String name;
  final double? radius;
  const UserAvatar(
      {super.key, required this.id, required this.name, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      // foregroundImage: CachedImage,
      // backgroundImage: AssetImage(Config.instance().logoPath),
      backgroundColor: Color.fromARGB(255, id.codeUnitAt(0) % 255,
          id.codeUnitAt(1) % 255, id.codeUnitAt(2) % 255),
      child: Text(name.isNotEmpty ? name.substring(0, 1) : id.substring(0, 1)),
    );
  }
}

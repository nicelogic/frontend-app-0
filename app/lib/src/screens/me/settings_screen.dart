import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('settings'),
        ),
        body: Column(children: [
          InkWell(
              onTap: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
                context.go(routePathLogin);
              },
              child: Card(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(1, 20, 15, 20),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[Text('Log Out')])),
                      ]))))
        ]));
  }
}

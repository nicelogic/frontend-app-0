import 'dart:developer';

import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/features/me/me.dart' as me;
import 'package:app/src/features/repositorys/repositorys.dart' as repositorys;
import 'package:app/src/features/auth/auth.dart' as auth;
import 'package:user_repository/user_repository.dart' as user_repository;

const String _kLogSource = 'EditNameScreen';

class EditNameScreen extends StatelessWidget {
  const EditNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => me.MeBloc(
            userRepository:
                context.read<repositorys.RepositorysCubit>().userRepository,
            authBloc: context.read<auth.AuthBloc>()),
        child: _EditNameScreen());
  }
}

class _EditNameScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<me.MeBloc, me.MeState>(
              listenWhen: (previous, current) =>
                  current.me.error != user_repository.UserError.none,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.me.error.name)));
              }),
          BlocListener<me.MeBloc, me.MeState>(
              listenWhen: (previous, current) =>
                  previous.me.name != current.me.name,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('update name success')));
                context.pop();
              }),
        ],
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Edit Name'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  color: Colors.white,
                  onPressed: () {
                    final updatedName = _controller.text;
                    log(name: _kLogSource, 'update name: $updatedName');
                    context.read<me.MeBloc>().add(me.UpdateName(updatedName));
                  },
                )
              ],
            ),
            body: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: TextForm(
                  inputLabel: 'Pick a name friends will remember',
                  controller: _controller,
                  validator: (name) =>
                      name != null && name.isNotEmpty ? name : null,
                ))));
  }
}

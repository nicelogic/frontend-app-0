import 'dart:developer';

import 'package:app/src/features/me/me.dart';
import 'package:app/src/route.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/features/my_profile/my_profile.dart' as my_profile;
import 'package:tuple/tuple.dart';
import 'package:user_repository/user_repository.dart' as user_repository;

const String _kLogSource = 'EditSignatureScreen';

class EditSignatureScreen extends StatelessWidget {
  final my_profile.MyProfileBloc myProfileBloc;
  final MeBloc meBloc;
  const EditSignatureScreen(
      {required this.myProfileBloc, required this.meBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider.value(value: myProfileBloc),
      BlocProvider.value(value: meBloc),
    ], child: _EditSignatureScreen());
  }
}

class _EditSignatureScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<my_profile.MyProfileBloc, my_profile.MyProfileState>(
              listenWhen: (previous, current) =>
                  current.myProfile.error != user_repository.UserError.none,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      SnackBar(content: Text(state.myProfile.error.name)));
              }),
          BlocListener<my_profile.MyProfileBloc, my_profile.MyProfileState>(
              listenWhen: (previous, current) =>
                  previous.myProfile.signature != current.myProfile.signature,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text('update signature success')));
                context.go('$routePathMe/$routePathMyProfile',
                    extra: Tuple2<MeBloc, my_profile.MyProfileBloc>(
                        context.read<MeBloc>(),
                        context.read<my_profile.MyProfileBloc>()));
              }),
        ],
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Edit Signature'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    final updatedSignature = _controller.text;
                    log(
                        name: _kLogSource,
                        'update signature: $updatedSignature');
                    context
                        .read<my_profile.MyProfileBloc>()
                        .add(my_profile.UpdateSignature(updatedSignature));
                  },
                )
              ],
            ),
            body: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: TextForm(
                  inputLabel: 'set signature',
                  controller: _controller,
                  validator: (name) =>
                      name != null && name.isNotEmpty ? name : null,
                ))));
  }
}
